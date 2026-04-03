{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nim
    # TODO: re-enable when build is fixed
    # nimlangserver
  ];
}
