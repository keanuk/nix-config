{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama;
    port = 11434;
    acceleration = null;
  };
}
