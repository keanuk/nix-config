{ pkgs, ... }:

{
  services = {
    ollama = {
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
    open-webui = {
      enable = true;
      package = pkgs.open-webui;
      openFirewall = false;
      port = 11435;
    };
  };
}
