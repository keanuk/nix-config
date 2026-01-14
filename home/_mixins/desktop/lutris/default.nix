{
  pkgs,
  osConfig,
  ...
}:
{
  programs.lutris = {
    enable = true;
    package = pkgs.lutris;
    steamPackage = osConfig.programs.steam.package;
    defaultWinePackage = pkgs.proton-ge-bin;
    protonPackages = with pkgs; [
      proton-ge-bin
    ];
    winePackages = with pkgs; [
      wineWow64Packages.full
    ];
  };
}
