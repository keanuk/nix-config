{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      ...
    }:
    {
      programs.lutris = {
        enable = true;
        # Pinned to stable until gtk2 dependency is removed
        package = pkgs.stable.lutris;
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
