{
  description = "Keanu's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    # Nix hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";	
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "stable";	
    };

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode Server
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # COSMIC Desktop
    cosmic-applets = {
      url = "github:pop-os/cosmic-applets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cosmic-applibrary = {
      url = "github:pop-os/cosmic-applibrary";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-bg = {
      url = "github:pop-os/cosmic-bg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cosmic-comp = {
      url = "github:pop-os/cosmic-comp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cosmic-launcher = {
      url = "github:pop-os/cosmic-launcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cosmic-notifications = {
      url = "github:pop-os/cosmic-notifications";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cosmic-osd = {
      url = "github:pop-os/cosmic-osd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cosmic-panel = {
      url = "github:pop-os/cosmic-panel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # cosmic-protocols.url = "github:pop-os/cosmic-protocols";
    
    cosmic-settings = {
      url = "github:pop-os/cosmic-settings";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cosmic-settings-daemon = {
      url = "github:pop-os/cosmic-settings-daemon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    cosmic-session = {
      url = "github:pop-os/cosmic-session";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # cosmic-text.url = "github:pop-os/cosmic-text";
    # cosmic-text-editor.url = "github:pop-os/cosmic-text-editor";
    # cosmic-theme.url = "github:pop-os/cosmic-theme";
    # cosmic-theme-editor.url = "github:pop-os/cosmic-theme-editor";
    # cosmic-time.url = "github:pop-os/cosmic-time";
    # cosmic-workspaces-epoch.url = "github:pop-os/cosmic-workspaces-epoch";
    # libcosmic.url = "github:pop-os/libcosmic";
    
    xdg-desktop-portal-cosmic = {
      url = "github:pop-os/xdg-desktop-portal-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = inputs@{ self, nixpkgs, stable, nixos-hardware, home-manager, home-manager-stable, lanzaboote, vscode-server, 
    cosmic-applets, cosmic-applibrary, cosmic-bg, cosmic-comp, cosmic-launcher, cosmic-notifications, cosmic-osd,
    cosmic-panel, cosmic-settings, cosmic-settings-daemon, cosmic-session, xdg-desktop-portal-cosmic, ... }: {
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
          nixos-hardware.nixosModules.hp-elitebook-845g7
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
          vscode-server.nixosModules.default
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
          vscode-server.nixosModules.default
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
          vscode-server.nixosModules.default
        ];
      };
    };
  };
}
