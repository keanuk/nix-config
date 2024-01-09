{
  description = "Keanu's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";	
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "stable";	
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };    
  };

  outputs = { 
    self, 
    nixpkgs, 
    stable, 
    nixos-hardware, 
    home-manager, 
    home-manager-stable, 
    lanzaboote, 
    ... 
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ]
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      earth = stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          {
            networking.hostName = "earth";
            system.stateVersion = "23.05";
          }
          ./hardware/terra.nix
          ./nix/configuration.nix
          ./packages/packages.nix
          ./packages/server.nix
          ./server/data.nix
          ./server/download.nix
          ./server/media.nix
          ./server/network.nix
          ./system/btrfs.nix
          ./system/network.nix
          ./system/server.nix
          ./system/system.nix
          ./system/systemd-boot.nix
          ./user/keanu/users.nix
          home-manager-stable.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.keanu = {
              imports = [ 
                ./user/keanu/home.nix
                ./user/keanu/server.nix 
              ];
              #manual.manpages.enable = false;
              home.stateVersion = "23.05";
            };
          }
        ];
      };
      enterprise = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          {
            networking.hostName = "enterprise";
            system.stateVersion = "23.05";
          }
          nixos-hardware.nixosModules.hp-elitebook-845g8
          ./desktop/cosmic.nix
          ./desktop/desktop.nix
          ./desktop/gnome.nix
          ./hardware/enterprise.nix
          ./nix/configuration.nix
          ./packages/desktop.nix
          ./packages/packages.nix
          ./system/btrfs.nix
          ./system/desktop.nix
          ./system/lanzaboote.nix
          ./system/network.nix
          ./system/power.nix
          ./system/system.nix
          ./user/keanu/users.nix
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.keanu = {
              imports = [ 
                ./user/keanu/desktop.nix
                ./user/keanu/home.nix
              ];
              home.stateVersion = "23.11";
            };
          }
          lanzaboote.nixosModules.lanzaboote
        ];
      };
      hermes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          {
            networking.hostName = "hermes";
            system.stateVersion = "23.05";
          }
          ./desktop/cosmic.nix
          ./desktop/desktop.nix
          ./desktop/gnome.nix
          ./hardware/hermes.nix
          ./nix/configuration.nix
          ./packages/desktop.nix
          ./packages/packages.nix
          ./system/btrfs.nix
          ./system/desktop.nix
          ./system/lanzaboote.nix
          ./system/network.nix
          ./system/power.nix
          ./system/system.nix
          ./user/keanu/users.nix
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.keanu = {
              imports = [ 
                ./user/keanu/desktop.nix 
                ./user/keanu/home.nix 
              ];
              home.stateVersion = "23.11";
            };
          }
          lanzaboote.nixosModules.lanzaboote
        ];
      };
      terra = stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          {
            networking.hostName = "terra";
            system.stateVersion = "23.05";
          }
          ./hardware/terra.nix
          ./nix/configuration.nix
          ./packages/packages.nix
          ./packages/server.nix
          ./server/data.nix
          ./server/download.nix
          ./server/media.nix
          ./server/network.nix
          ./system/btrfs.nix
          ./system/network.nix
          ./system/server.nix
          ./system/system.nix
          ./system/systemd-boot.nix
          ./user/keanu/users.nix
          home-manager-stable.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.keanu = {
              imports = [ 
                ./user/keanu/home.nix
                ./user/keanu/server.nix 
              ];
              #manual.manpages.enable = false;
              home.stateVersion = "23.05";
            };
          }
        ];
      };
      titan = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          {
   	        networking.hostName = "titan";
            system.stateVersion = "23.05";
          }
          ./desktop/cosmic.nix
          ./desktop/desktop.nix
          ./desktop/gnome.nix
          ./hardware/titan.nix
          ./nix/configuration.nix
          ./packages/desktop.nix
          ./packages/packages.nix
          ./system/amd.nix
          ./system/btrfs.nix
          ./system/desktop.nix
          ./system/lanzaboote.nix
          ./system/network.nix
          ./system/system.nix
          ./user/keanu/users.nix
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.keanu = {
              imports = [ 
                ./user/keanu/desktop.nix 
                ./user/keanu/home.nix 
              ];
              home.stateVersion = "23.11";
            };
          }
          lanzaboote.nixosModules.lanzaboote
        ];
      };
    };
  };
}
