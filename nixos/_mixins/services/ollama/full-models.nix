# Full Ollama model list for powerful hosts (beehive, titan, phoebe)
#
# Import this alongside the base ollama mixin on hosts with enough
# resources to run larger models:
#
#   imports = [
#     ../_mixins/services/ollama
#     ../_mixins/services/ollama/full-models.nix
#   ];
_: {
  services.ollama.loadModels = [
    "codestral:latest"
    "deepseek-r1:latest"
    "devstral-small-2:latest"
    "gemma3:latest"
    "gemma3n:latest"
    "gpt-oss:latest"
    "magistral:latest"
    "mistral:latest"
    "qwen3:latest"
    "qwen3-coder:latest"
  ];
}
