{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      services.ollama = {
        enable = false;
        package = pkgs.unstable.ollama;
        port = 11434;
        acceleration = null;
      };
    };
}
