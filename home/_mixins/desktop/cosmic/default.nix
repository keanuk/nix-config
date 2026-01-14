{ pkgs, ... }:
{
  home.packages = with pkgs; [
    forecast
    tasks
  ];
}
