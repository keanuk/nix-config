{
  description = "Keanu's Nix Configuration - Multi-platform NixOS and nix-darwin setup";

  # Note: For VPS hosts (bucaccio, emilyvansant), use deploy-rs to build remotely
  # and deploy pre-built closures. Do NOT run nixos-rebuild on the VPS itself
  # as the limited resources will cause builds to hang.
  #
  # Usage: nix run .#deploy-rs -- .#bucaccio
  #    or: nix run .#deploy-rs -- .#emilyvansant

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
    allow-import-from-derivation = "true";
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

    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    nixos-facter = {
      url = "github:numtide/nixos-facter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv";
  };

  outputs =
    {
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
    }@inputs:
    let
      inherit (self) outputs;

      # Custom library functions
      domains = import ./lib/domains.nix;
      mkHomeManagerHost = import ./lib/mkHost.nix;

      lib =
        nixpkgs.lib
        // home-manager.lib
        // darwin.lib
        // {
          inherit domains mkHomeManagerHost;
        };
      lib-stable =
        nixpkgs-stable.lib
        // home-manager-stable.lib
        // {
          inherit domains mkHomeManagerHost;
        };
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ inputs.nix-openclaw.overlays.default ];
          config = {
            allowUnfree = true;
            allowImportFromDerivation = true;
          };
        }
      );
      pkgsFor-stable = lib.genAttrs (import systems) (
        system:
        import nixpkgs-stable {
          inherit system;
          config = {
            allowUnfree = true;
            allowImportFromDerivation = true;
          };
        }
      );

      # Host configuration helpers — eliminate repetitive specialArgs/extraSpecialArgs
      commonArgs = {
        inherit
          self
          inputs
          outputs
          domains
          mkHomeManagerHost
          ;
      };
      mkNixosHost = import ./lib/mkNixosHost.nix (commonArgs // { inherit lib; });
      mkNixosHost-stable = import ./lib/mkNixosHost.nix (commonArgs // { lib = lib-stable; });
      mkDarwinHost = import ./lib/mkDarwinHost.nix (commonArgs // { inherit lib; });
      mkHomeConfig = import ./lib/mkHomeConfig.nix { inherit inputs outputs lib; };
      mkHomeConfig-stable = import ./lib/mkHomeConfig.nix {
        inherit inputs outputs;
        lib = lib-stable;
      };
    in
    {
      inherit lib lib-stable;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };
      hydraJobs = import ./hydra.nix { inherit inputs outputs; };

      packages = forEachSystem (
        pkgs:
        (import ./pkgs { inherit pkgs; })
        // (lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          iso = nixos-generators.nixosGenerate {
            inherit (pkgs) system;
            modules = [
              ./nixos/iso
            ];
            format = "install-iso";
            specialArgs = { inherit inputs outputs; };
          };
        })
        // {
          nixos-anywhere = nixos-anywhere.packages.${pkgs.system}.default;
          deploy-rs = inputs.deploy-rs.packages.${pkgs.system}.default;
        }
      );
      devShells = forEachSystem (pkgs: import ./shells.nix { inherit pkgs inputs; });
      formatter = forEachSystem (pkgs: pkgs.nixfmt-tree);

      # ===== NixOS Configurations =====
      nixosConfigurations = {
        # Beelink SER9 Pro
        # TODO: Switch back to stable when 26.05 is released
        beehive = mkNixosHost { modules = [ ./nixos/beehive ]; };
        # Intel NUC 10 i7
        earth = mkNixosHost { modules = [ ./nixos/earth ]; };
        # HP EliteBook 845 G8
        hyperion = mkNixosHost { modules = [ ./nixos/hyperion ]; };
        # ThinkPad X13s Gen 1
        mars = mkNixosHost { modules = [ ./nixos/mars ]; };
        # HP EliteBook 1030 G2
        miranda = mkNixosHost { modules = [ ./nixos/miranda ]; };
        # ThinkPad P14s AMD Gen 5
        phoebe = mkNixosHost { modules = [ ./nixos/phoebe ]; };
        # Zotac ZBox
        tethys = mkNixosHost { modules = [ ./nixos/tethys ]; };
        # CyberPowerPC
        titan = mkNixosHost { modules = [ ./nixos/titan ]; };

        # ===== VPS =====
        # Bucaccio Website Hetzner us-east-1
        bucaccio = mkNixosHost-stable { modules = [ ./nixos/vps/bucaccio ]; };
        # Emily Van Sant Website Hetzner
        emilyvansant = mkNixosHost-stable { modules = [ ./nixos/vps/emilyvansant ]; };
        # Love Alaya Website Hetzner
        love-alaya = mkNixosHost-stable { modules = [ ./nixos/vps/love-alaya ]; };
      };

      # ===== Darwin Configurations =====
      darwinConfigurations = {
        # Mac Mini 2024
        salacia = mkDarwinHost { modules = [ ./darwin/salacia ]; };
        # MacBook Pro 2020
        vesta = mkDarwinHost { modules = [ ./darwin/vesta ]; };
        # MacBook Air 2018
        charon = mkDarwinHost { modules = [ ./darwin/charon ]; };
      };

      # ===== Deploy-rs =====
      # Remote deployments for resource-constrained VPS hosts
      deploy.nodes = {
        bucaccio = {
          hostname = "vps.bucaccio.com";
          profiles.system = {
            user = "root";
            sshUser = "keanu";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bucaccio;
          };
        };
        emilyvansant = {
          hostname = "vps.emilyvansant.com";
          profiles.system = {
            user = "root";
            sshUser = "keanu";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.emilyvansant;
          };
        };
        love-alaya = {
          hostname = "love-alaya.com";
          profiles.system = {
            user = "root";
            sshUser = "keanu";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.love-alaya;
          };
        };
      };

      # Checks for deploy-rs
      checks = forEachSystem (pkgs: inputs.deploy-rs.lib.${pkgs.system}.deployChecks self.deploy);

      # ===== Home Manager Configurations =====
      homeConfigurations = {
        # TODO: Switch back to stable when 26.05 is released
        "keanu@beehive" = mkHomeConfig {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/beehive/keanu.nix ];
        };
        "keanu@charon" = mkHomeConfig {
          pkgs = pkgsFor.x86_64-darwin;
          modules = [ ./home/charon/keanu.nix ];
        };
        "keanu@earth" = mkHomeConfig {
          pkgs = pkgsFor-stable.x86_64-linux;
          modules = [ ./home/earth/keanu.nix ];
        };
        "keanu@hyperion" = mkHomeConfig {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/hyperion/keanu.nix ];
        };
        "keanu@mars" = mkHomeConfig {
          pkgs = pkgsFor.aarch64-linux;
          modules = [ ./home/mars/keanu.nix ];
        };
        "keanu@miranda" = mkHomeConfig {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/miranda/keanu.nix ];
        };
        "keanu@phoebe" = mkHomeConfig {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/phoebe/keanu.nix ];
        };
        "keanu@salacia" = mkHomeConfig {
          pkgs = pkgsFor.aarch64-darwin;
          modules = [ ./home/salacia/keanu.nix ];
        };
        "keanu@tethys" = mkHomeConfig {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/tethys/keanu.nix ];
        };
        "keanu@titan" = mkHomeConfig {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/titan/keanu.nix ];
        };
        "keanu@vesta" = mkHomeConfig {
          pkgs = pkgsFor.x86_64-darwin;
          modules = [ ./home/vesta/keanu.nix ];
        };
        # ===== VPS =====
        "keanu@bucaccio" = mkHomeConfig-stable {
          pkgs = pkgsFor-stable.x86_64-linux;
          modules = [ ./home/vps/bucaccio/keanu.nix ];
        };
        "keanu@emilyvansant" = mkHomeConfig-stable {
          pkgs = pkgsFor-stable.x86_64-linux;
          modules = [ ./home/vps/emilyvansant/keanu.nix ];
        };
        "keanu@love-alaya" = mkHomeConfig-stable {
          pkgs = pkgsFor-stable.x86_64-linux;
          modules = [ ./home/vps/love-alaya/keanu.nix ];
        };
      };
    };
}
