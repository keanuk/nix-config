{
  description = "Keanu's Nix";

  nixConfig = {
    extra-substituters = [
      "https://keanu.cachix.org"
    ];
    extra-trusted-public-keys = [
      "keanu.cachix.org-1:bnYEu6tJzXfwM5JkEhc90uEjR7cAHwaa4fwHRCYdFGg="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    systems.url = "github:nix-systems/default";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    
    hydra = {
      url = "github:nixos/hydra";
      inputs.nixpkgs.follows = "nixpkgs";
    };   
    
    nix-colors.url = "github:misterio77/nix-colors";

    stylix.url = "github:danth/stylix";

    hyprland = {
      # url = "github:hyprwm/Hyprland";
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    vpn-confinement = {
      url = "github:Maroka-chan/VPN-Confinement";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };  
    
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
      lib = nixpkgs.lib // home-manager.lib;
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }
      );      
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/git/secrets.json");
      username = "keanu";
    in {
      inherit lib;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays {inherit inputs outputs;};
      hydraJobs = import ./hydra.nix {inherit inputs outputs;};

      packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
      devShells = forEachSystem (pkgs: import ./shells.nix {inherit pkgs;});
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        earth = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/earth ];
        };
        enterprise = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/enterprise ];
        };
        hermes = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/hermes ];
        };
        terra = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/terra ];
        };
        titan = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/titan ];
        };
      };
      darwinConfigurations = {
        phoenix = darwin.lib.darwinSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/phoenix ];
        };
      };
      homeConfigurations = {
        # for non-NixOS/Darwin systems
      };
    };
}
