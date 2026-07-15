{ config, ... }:
let
  hmRoles = with config.flake.modules.homeManager; [
    darwin-profile
    sops
    openclaw
  ];

  salaciaKeanuHome =
    {
      config,
      lib,
      ...
    }:
    {
      imports = hmRoles;

      sops.secrets = {
        openclaw_telegram_bot_token_salacia = { };
        openclaw_mistral_api_key = { };
        openclaw_gateway_token = { };
        openclaw_openai_api_key = { };
      };

      # Configure Darwin-specific sops paths for all openclaw secrets since /run/secrets is Linux-only.
      programs.openclawSecrets = {
        telegramTokenFile = lib.mkForce config.sops.secrets.openclaw_telegram_bot_token_salacia.path;
        mistralApiKeyFile = lib.mkForce config.sops.secrets.openclaw_mistral_api_key.path;
        gatewayTokenFile = lib.mkForce config.sops.secrets.openclaw_gateway_token.path;
        openaiApiKeyFile = lib.mkForce config.sops.secrets.openclaw_openai_api_key.path;
        # salacia talks to a remote/keyed Ollama server; reuse the sops-managed
        # ollama_api_key for openclaw's ollama auth profile (hosts without this
        # override keep the local "ollama-local" placeholder, e.g. beehive).
        ollamaApiKeyFile = lib.mkForce config.sops.secrets.ollama_api_key.path;
        primaryModel = lib.mkForce "ollama/gpt-oss:latest";
        fallbackModels = lib.mkForce [
          "ollama/mistral:latest"
          "ollama/gemma4:latest"
        ];
      };

      # Set baseUrl to point openclaw's Ollama provider to the remote ursa server.
      programs.openclaw.instances.default.config.models.providers.ollama.baseUrl = "http://ursa:11434";

      home.stateVersion = "25.11";
    };
in
{
  configurations.darwin.salacia.module.home-manager.users.keanu = salaciaKeanuHome;

  configurations.homeManager."keanu@salacia" = {
    system = "aarch64-darwin";
    module = salaciaKeanuHome;
  };
}
