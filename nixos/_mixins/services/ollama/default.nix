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
      "codestral"
      "deepseek-r1"
      "devstral"
      "gemma3"
      "gemma3n"
      "magistral"
      "mistral"
      "mistral-small"
      "qwen3"
      "qwen3-coder"
    ];
  };
}
