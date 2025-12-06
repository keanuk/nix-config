{
  pkgs,
  lib,
  ...
}: {
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    port = lib.mkDefault 11434;
    openFirewall = lib.mkDefault false;
    user = "ollama";
    group = "ollama";
    home = lib.mkDefault "/var/lib/ollama";
    loadModels = [
      "codestral:latest"
      "deepseek-r1:latest"
      "devstral:latest"
      "gemma3:latest"
      "gemma3n:latest"
      "magistral:latest"
      "mistral:latest"
      "mistral-small:latest"
      "qwen3:latest"
      "qwen3-coder:latest"
    ];
  };
}
