{ pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    profiles = {
      "main" = {
        isDefault = true;
      };
    };
  };
}
