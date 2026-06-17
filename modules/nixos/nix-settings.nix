{
  config,
  inputs,
  ...
}:
let
  baseOverlays =
    with config.flake.overlays;
    [
      unstable-packages
      stable-packages
      additions
      modifications
    ]
    ++ [
      inputs.nix-openclaw.overlays.default
      inputs.hyprland.overlays.hyprland-packages
      inputs.hyprland.overlays.hyprland-extras
    ];
in
{
  flake.modules.nixos.nix-settings = {
    nix = {
      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";
      registry = {
        my.flake = inputs.self;
        home-manager.flake = inputs.home-manager;
        darwin.flake = inputs.darwin;
      };
      settings = {
        auto-optimise-store = true;
        warn-dirty = false;
        auto-allocate-uids = true;
        allowed-users = [ "@users" ];
        experimental-features = [
          "nix-command"
          "flakes"
          "ca-derivations"
          "auto-allocate-uids"
        ];
        system-features = [
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://install.determinate.systems"
          "https://keanu.cachix.org"
          "https://nix-community.cachix.org"
          "https://cache.oranos.org"
        ];
        trusted-public-keys = [
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
          "keanu.cachix.org-1:bnYEu6tJzXfwM5JkEhc90uEjR7cAHwaa4fwHRCYdFGg="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.oranos.org-1:3Mq4GQlwD5RtY+bGKdhmFX0HvooDo3i4ZmGV2oHq74M="
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 5d";
      };
    };

    nixpkgs = {
      overlays = baseOverlays;
      config = {
        allowUnfree = true;
        allowImportFromDerivation = true;
      };
    };
  };

  flake.modules.nixos.base = config.flake.modules.nixos.nix-settings;
}
