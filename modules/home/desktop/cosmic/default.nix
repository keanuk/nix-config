{
  flake.modules.homeManager.cosmic =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        forecast
        tasks
      ];
    };
}
