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
    loadModels = [
      "codestral:latest"
      "deepseek-r1:latest"
      "devstral-small-2:latest"
      "gemma3:latest"
      "gemma3n:latest"
      "gpt-oss:latest"
      "magistral:latest"
      "mistral:latest"
      "ministral-3:latest"
      "qwen3:latest"
      "qwen3-coder:latest"
    ];
  };
}
