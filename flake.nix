{
  description = "Keanu's Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
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
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , nixos-hardware
    , darwin
    , home-manager
    , home-manager-stable
    , nix-colors
    , hyprland
    , hyprland-plugins
    , hyprwm-contrib
    , helix
    , nixvim
    , lanzaboote
    , disko
    , sops-nix
    , vpn-confinement
    , nixarr
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      linuxSystems = [ "aarch64-linux" "x86_64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems);
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/git/secrets.json");
      username = "keanu";
      libx = import ./lib { inherit self inputs outputs secrets username; };
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        earth = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          system = "x86_64-linux";
          modules = [ ./hosts/earth ];
        };
        enterprise = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          system = "x86_64-linux";
          modules = [ ./hosts/enterprise ];
        };
        hermes = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          system = "x86_64-linux";
          modules = [ ./hosts/hermes ];
        };
        terra = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          system = "x86_64-linux";
          modules = [ ./hosts/terra ];
        };
        titan = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          system = "x86_64-linux";
          modules = [ ./hosts/titan ];
        };
      };
      darwinConfigurations = {
        phoenix = darwin.lib.darwinSystem {
          specialArgs = { inherit inputs outputs secrets; };
          system = "x86_64-darwin";
          modules = [ ./hosts/phoenix ];
        };
      };
      homeConfigurations = {
        # for non-NixOS/Darwin systems
      };
    };
}
