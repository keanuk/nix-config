{
  flake.modules.homeManager.cosmic-tray =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        forecast
        tasks
      ];
    };
}
