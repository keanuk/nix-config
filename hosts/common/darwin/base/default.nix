{ ... }:

{
  imports = [
    ./homebrew.nix
    ./packages.nix
  ];

  nix = {
    gc = {
      user = "keanu";
      automatic = true;
      interval = { Weekday = 1; Hour = 0; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    optimise = {
      user = "keanu";
      automatic = true;
    };
    settings = {
      allowed-users = [ "@users" "keanu" "root" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  programs.zsh.enable = true;
}
