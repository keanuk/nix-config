{ config, ... }:
{
  flake.modules.nixos = {
    # Base Ollama service for resource-constrained hosts
    ollama =
      {
        pkgs,
        lib,
        ...
      }:
      {
        services.ollama = {
          enable = true;
          package = lib.mkDefault pkgs.unstable.ollama-cpu;
          host = lib.mkDefault "0.0.0.0";
          port = lib.mkDefault 11434;
          openFirewall = lib.mkDefault true;
          user = "ollama";
          group = "ollama";
          home = lib.mkDefault "/var/lib/ollama";
          loadModels = lib.mkDefault [
            "gemma4:e2b"
          ];
        };
      };

    # Medium Ollama model list for mid-range hosts (laptops, mini PCs: beehive, titan, phoebe, luna)
    ollama-medium = _: {
      services.ollama.loadModels = [
        "deepseek-r1:latest" # 7B/8B distilled
        "gemma3n:latest" # 4B/8B edge/laptop
        "gemma4:latest" # 12B dense
        "gpt-oss:latest" # 8B
        "magistral:latest" # 8B
        "mistral:latest" # 7B
      ];
    };

    # High-end Ollama model list for workstations/servers (e.g. ursa, titan)
    ollama-high = _: {
      services.ollama.loadModels = [
        "codestral:latest" # 22B code model
        "deepseek-r1:32b" # 32B distilled reasoning model
        "devstral-small-2:latest" # 24B software engineering model
        "gemma4:31b" # 31B dense reasoning model
        "qwen3.6:latest" # 27B/35B dense/MoE general model
        "qwen3-coder-next:latest" # 30B code model
      ];
    };

    server = config.flake.modules.nixos.ollama;
  };
}
