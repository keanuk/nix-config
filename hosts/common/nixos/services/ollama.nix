{ pkgs, ... }:

{
  # TODO: re-enable when the build succeeds
  # imports = [
  #   ./open-webui.nix
  # ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama;
    loadModels = [
    "codestral"
    "deepseek-r1"
    "gemma3"
    "mistral"
    "mistral-small"
    "qwen3"
    ];
  };
}
