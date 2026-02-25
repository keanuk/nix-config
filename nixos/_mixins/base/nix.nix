{
  self,
  inputs,
  outputs,
  ...
}:
{
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    registry = {
      my.flake = self;
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
        "https://keanu.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "keanu.cachix.org-1:bnYEu6tJzXfwM5JkEhc90uEjR7cAHwaa4fwHRCYdFGg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +5";
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.stable-packages
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };
}
