{ config, pkgs, ... }:

{
  nix = {
    gc = {
      user = "keanu";
      automatic = true;
      interval = { Weekday = 0; Hour = 0; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    settings = {
      allowed-users = [ "@users" ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  programs.zsh.enable = true;
}
