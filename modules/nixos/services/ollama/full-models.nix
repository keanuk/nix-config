{
  # Full Ollama model list for powerful hosts (beehive, titan, phoebe)
  #
  # Use this role alongside ollama on hosts with enough resources to run
  # larger models.
  flake.modules.nixos.ollama-full = _: {
    services.ollama.loadModels = [
      "codestral:latest"
      "deepseek-r1:latest"
      "devstral-small-2:latest"
      "gemma4:latest"
      "gemma3n:latest"
      "gpt-oss:latest"
      "magistral:latest"
      "mistral:latest"
      "qwen3.6:latest"
      "qwen3-coder-next:latest"
    ];
  };
}
