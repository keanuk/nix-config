{ pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird;
    profiles = {
      "main" = {
        isDefault = true;
      };
    };
  };
}
