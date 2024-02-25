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
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixos-hardware,
    darwin,
    home-manager,
    home-manager-stable,
    lanzaboote,
    disko,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    linuxSystems = [ "aarch64-linux" "x86_64-linux" ];
    darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems);
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/git/secrets.json");
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      earth = nixpkgs-stable.lib.nixosSystem {
        specialArgs = {inherit inputs outputs secrets;};
        system = "x86_64-linux";
        modules = [ ./hosts/earth ];
      };
      enterprise = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs secrets;};
        system = "x86_64-linux";
        modules = [ ./hosts/enterprise ];
      };
      hermes = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs secrets;};
        system = "x86_64-linux";
        modules = [ ./hosts/hermes ];
      };
      terra = nixpkgs-stable.lib.nixosSystem {
        specialArgs = {inherit inputs outputs secrets;};
        system = "x86_64-linux";
        modules = [ ./hosts/terra ];
      };
      titan = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs secrets;};
        system = "x86_64-linux";
        modules = [ ./hosts/titan ];
      };
    };
    darwinConfigurations = {
      phoenix = darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs secrets;};
        system = "x86_64-darwin";
        modules = [ ./hosts/phoenix ];
      };
    };
  };
}
