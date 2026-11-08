{
  flake.modules.homeManager.desktop =
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
}
