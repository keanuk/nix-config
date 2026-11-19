{ config, ... }:
{
  flake.modules.homeManager.lutris =
    {
      pkgs,
      ...
    }:
    {
      programs.lutris = {
        enable = true;
        package = pkgs.lutris;
        defaultWinePackage = pkgs.proton-ge-bin;
        protonPackages = with pkgs; [
          proton-ge-bin
        ];
        winePackages = with pkgs; [
          wineWow64Packages.full
        ];
      };
    };

  flake.modules.homeManager.desktop = config.flake.modules.homeManager.lutris;
}
