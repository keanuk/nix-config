{ ... }:

{
  imports = [
    ./homebrew.nix
    ./packages.nix

    ../../dev/default.nix

    ../../desktop/fonts.nix
  ];

  nix = {
    # Disabled for Determinate Nix
    enable = false;
    gc = {
      automatic = true;
      interval = { Weekday = 1; Hour = 0; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;

    settings = {
      allowed-users = [ "@users" "keanu" "root" ];
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://cache.nixos.org"
        "https://keanu.cachix.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://cosmic.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "keanu.cachix.org-1:bnYEu6tJzXfwM5JkEhc90uEjR7cAHwaa4fwHRCYdFGg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      trusted-users = [
        "root"
        "keanu"
        "@wheel"
      ];
    };
  };
}
