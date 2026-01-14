{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    port = 11434;
    acceleration = null;
  };
}
