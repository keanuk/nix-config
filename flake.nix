{
  description = "Keanu's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";	
    };

    # COSMIC Desktop
    # cosmic-epoch.url = "github:pop-os/cosmic-epoch";
    cosmic-applets.url = "github:pop-os/cosmic-applets";
    cosmic-applibrary.url = "github:pop-os/cosmic-applibrary";
    cosmic-comp.url = "github:pop-os/cosmic-comp";
	cosmic-launcher.url = "github:pop-os/cosmic-launcher";
	cosmic-notifications.url = "github:pop-os/cosmic-notifications";
	cosmic-osd.url = "github:pop-os/cosmic-osd";
	cosmic-panel.url = "github:pop-os/cosmic-panel";
	# cosmic-protocols.url = "github:pop-os/cosmic-protocols";
	cosmic-settings.url = "github:pop-os/cosmic-settings";
	cosmic-settings-daemon.url = "github:pop-os/cosmic-settings-daemon";
	cosmic-session.url = "github:pop-os/cosmic-session";
	# cosmic-text.url = "github:pop-os/cosmic-text";
	# cosmic-text-editor.url = "github:pop-os/cosmic-text-editor";
	# cosmic-theme.url = "github:pop-os/cosmic-theme";
	# cosmic-theme-editor.url = "github:pop-os/cosmic-theme-editor";
	# cosmic-time.url = "github:pop-os/cosmic-time";
	# cosmic-workspaces-epoch.url = "github:pop-os/cosmic-workspaces-epoch";
	# libcosmic.url = "github:pop-os/libcosmic";
	xdg-desktop-portal-cosmic.url = "github:pop-os/xdg-desktop-portal-cosmic";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      hermes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./desktop/cosmic.nix
          ./desktop/desktop.nix
          ./desktop/gnome.nix
          ./hardware/hermes.nix
          ./nix/configuration.nix
          ./packages/packages.nix
          ./system/network.nix
          ./system/system.nix
          ./user/keanu/users.nix
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
		    home-manager.useGlobalPkgs = true;
		    home-manager.users.keanu = import ./user/keanu/home.nix;
          }
        ];
      };
    };
  };
}
