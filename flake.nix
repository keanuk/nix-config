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
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
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
      url = "github:nix-community/home-manager/release-24.05";
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

    nix-colors.url = "github:misterio77/nix-colors";

    stylix.url = "github:danth/stylix";

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

    nix-ld = {
      url = "github:Mic92/nix-ld";
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

    vpn-confinement = {
      url = "github:Maroka-chan/VPN-Confinement";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # COSMIC
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    xdg-desktop-portal-cosmic = {
      url = "github:pop-os/xdg-desktop-portal-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hypr
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprcursor = {
      url = "github:hyprwm/hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprsysteminfo = {
      url = "github:hyprwm/hyprsysteminfo";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
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
        enterprise = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/enterprise ];
        };
        # HP EliteBook 1030 G2
        hermes = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/hermes ];
        };
        # Zotac ZBox
        terra = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/terra ];
        };
        # CyberPowerPC
        titan = lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/titan ];
        };
      };
      darwinConfigurations = {
        # MacBook Air 2018
        phoenix = lib.darwinSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./hosts/phoenix ];
        };
      };
      homeConfigurations = {
        "keanu@earth" = lib-stable.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/earth.nix ];
        };
        "keanu@enterprise" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/enterprise.nix ];
        };
        "keanu@hermes" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/hermes.nix ];
        };
        "keanu@phoenix" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-darwin;
          modules = [ ./home/phoenix.nix ];
        };
        "keanu@terra" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/terra.nix ];
        };
        "keanu@titan" = lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs secrets; };
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/titan.nix ];
        };
      };
    };
}
