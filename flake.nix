{
  description = "Keanu's Nix";

  nixConfig = {
    extra-substituters = [
      "https://keanu.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://cosmic.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "keanu.cachix.org-1:bnYEu6tJzXfwM5JkEhc90uEjR7cAHwaa4fwHRCYdFGg="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    systems.url = "github:nix-systems/default";
    impermanence.url = "github:nix-community/impermanence";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nur.url = "github:nix-community/NUR";

    hydra = {
      url = "github:nixos/hydra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    nixarr.url = "github:rasmus-kirk/nixarr";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , systems
    , darwin
    , home-manager
    , home-manager-stable
    , ...
    } @ inputs:
    let
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
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/git/secrets.json");
    in
    {
      inherit lib lib-stable;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };
      hydraJobs = import ./hydra.nix { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shells.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        # Intel NUC 10 i7
        earth = lib-stable.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/earth ];
        };
        # HP EliteBook 845 G8
        hyperion = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/hyperion ];
        };
        # HP EliteBook 1030 G2
        miranda = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/miranda ];
        };
        # ThinkPad P14s AMD Gen 5
        phoebe = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/phoebe ];
        };
        # Zotac ZBox
        tethys = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/tethys ];
        };
        # CyberPowerPC
        titan = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/titan ];
        };
      };
      darwinConfigurations = {
        # MacBook Pro 2020
        vesta = lib.darwinSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/vesta ];
        };
        # MacBook Air 2018
        charon = lib.darwinSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/charon ];
        };
      };
      homeConfigurations = {
        "keanu@charon" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-darwin;
          modules = [ ./home/charon/keanu.nix ];
        };
        "keanu@earth" = lib-stable.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/earth/keanu.nix ];
        };
        "keanu@hyperion" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/hyperion/keanu.nix ];
        };
        "keanu@miranda" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/miranda/keanu.nix ];
        };
        "keanu@phoebe" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/phoebe/keanu.nix ];
        };
        "keanu@tethys" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/tethys/keanu.nix ];
        };
        "keanu@titan" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/titan/keanu.nix ];
        };
        "keanu@vesta" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-darwin;
          modules = [ ./home/vesta/keanu.nix ];
        };
      };
    };
}
