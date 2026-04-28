{
  flake.modules.homeManager.server =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        transmission_4
      ];
    };
}
