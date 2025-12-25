{
  description = "Keanu's Nix Configuration - Multi-platform NixOS and nix-darwin setup";

  # Binary cache configuration for faster builds
  nixConfig = {
    extra-substituters = [
      "https://keanu.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "keanu.cachix.org-1:bnYEu6tJzXfwM5JkEhc90uEjR7cAHwaa4fwHRCYdFGg="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Flake inputs - external dependencies
  inputs = {
    # Determinate Systems Nix installer and tooling
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # Nixpkgs - main package repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Hardware configurations and system support
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    systems.url = "github:nix-systems/default";

    # Stateful data management
    preservation.url = "github:nix-community/preservation";
    impermanence.url = "github:nix-community/impermanence";

    # WSL support for Windows Subsystem for Linux
    wsl.url = "github:nix-community/NixOS-WSL/main";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    hydra = {
      url = "github:nixos/hydra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    nixarr.url = "github:rasmus-kirk/nixarr";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    systems,
    darwin,
    home-manager,
    home-manager-stable,
    nixos-generators,
    nixos-anywhere,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib // darwin.lib;
    lib-stable = nixpkgs-stable.lib // home-manager-stable.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
    pkgsFor-stable = lib.genAttrs (import systems) (
      system:
        import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib lib-stable;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    overlays = import ./overlays {inherit inputs outputs;};
    hydraJobs = import ./hydra.nix {inherit inputs outputs;};

    packages = forEachSystem (pkgs:
      (import ./pkgs {inherit pkgs;})
      // {
        iso = nixos-generators.nixosGenerate {
          system = pkgs.system;
          modules = [
            ./nixos/iso
          ];
          format = "install-iso";
          specialArgs = {inherit inputs outputs;};
        };
        nixos-anywhere = nixos-anywhere.packages.${pkgs.system}.default;
      });
    devShells = forEachSystem (pkgs: import ./shells.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      # Beelink SER9 Pro
      beehive = lib-stable.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/beehive];
      };
      # Intel NUC 10 i7
      earth = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/earth];
      };
      # HP EliteBook 845 G8
      hyperion = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/hyperion];
      };
      # ThinkPad X13s Gen 1
      mars = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/mars];
      };
      # HP EliteBook 1030 G2
      miranda = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/miranda];
      };
      # ThinkPad P14s AMD Gen 5
      phoebe = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/phoebe];
      };
      # Zotac ZBox
      tethys = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/tethys];
      };
      # Hetzner VPS
      bucaccio = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/bucaccio];
      };
      # CyberPowerPC
      titan = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/titan];
      };
    };
    darwinConfigurations = {
      # Mac Mini 2024
      salacia = lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./darwin/salacia];
      };
      # MacBook Pro 2020
      vesta = lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./darwin/vesta];
      };
      # MacBook Air 2018
      charon = lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./darwin/charon];
      };
    };
    homeConfigurations = {
      "keanu@beehive" = lib-stable.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/beehive/keanu.nix];
      };
      "keanu@bucaccio" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/bucaccio/keanu.nix];
      };
      "keanu@charon" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-darwin;
        modules = [./home/charon/keanu.nix];
      };
      "keanu@earth" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor-stable.x86_64-linux;
        modules = [./home/earth/keanu.nix];
      };
      "keanu@hyperion" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/hyperion/keanu.nix];
      };
      "keanu@mars" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.aarch64-linux;
        modules = [./home/mars/keanu.nix];
      };
      "keanu@miranda" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/miranda/keanu.nix];
      };
      "keanu@phoebe" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/phoebe/keanu.nix];
      };
      "keanu@salacia" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.aarch64-darwin;
        modules = [./home/salacia/keanu.nix];
      };
      "keanu@tethys" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/tethys/keanu.nix];
      };
      "keanu@titan" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/titan/keanu.nix];
      };
      "keanu@vesta" = lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = pkgsFor.x86_64-darwin;
        modules = [./home/vesta/keanu.nix];
      };
    };
  };
}
