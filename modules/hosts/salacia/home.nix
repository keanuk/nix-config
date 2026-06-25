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

      # salacia talks to a remote/keyed Ollama server; reuse the sops-managed
      # ollama_api_key for openclaw's ollama auth profile (hosts without this
      # override keep the local "ollama-local" placeholder, e.g. beehive).
      programs.openclawSecrets.ollamaApiKeyFile = lib.mkDefault config.sops.secrets.ollama_api_key.path;

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
