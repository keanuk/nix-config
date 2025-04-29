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
      environment = ''
        {
          ANONYMIZED_TELEMETRY = "False";
          DO_NOT_TRACK = "True";
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          SCARF_NO_ANALYTICS = "True";
        }
      '';
    };
  };
}
