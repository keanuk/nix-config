{
  pkgs,
  lib,
  ...
}:
{
  services.ollama = {
    enable = true;
    package = lib.mkDefault pkgs.unstable.ollama-cpu;
    port = lib.mkDefault 11434;
    openFirewall = lib.mkDefault true;
    user = "ollama";
    group = "ollama";
    home = lib.mkDefault "/var/lib/ollama";
    loadModels = lib.mkDefault [
      "gemma3:1b"
    ];
  };
}
