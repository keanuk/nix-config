{ pkgs, ... }:

{
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama;
      loadModels = [
        "llama3.3"
        "mistral"
      ];
    };
    nextjs-ollama-llm-ui = {
      enable = true;
      package = pkgs.nextjs-ollama-llm-ui;
      ollamaUrl = "http://127.0.0.1:11434";
    };
  };
}
