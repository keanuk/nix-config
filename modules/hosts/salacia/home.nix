{ config, ... }:
let
  hmRoles = with config.flake.modules.homeManager; [
    darwin-profile
    sops
    openclaw
  ];

  salaciaKeanuHome =
    { config, ... }:
    {
      imports = hmRoles;

      sops.secrets = {
        openclaw_telegram_bot_token_salacia = { };
        openclaw_mistral_api_key = { };
        openclaw_gateway_token = { };
        openclaw_openai_api_key = { };
      };

      programs.openclawSecrets = {
        telegramTokenFile = config.sops.secrets.openclaw_telegram_bot_token_salacia.path;
        mistralApiKeyFile = config.sops.secrets.openclaw_mistral_api_key.path;
        gatewayTokenFile = config.sops.secrets.openclaw_gateway_token.path;
        openaiApiKeyFile = config.sops.secrets.openclaw_openai_api_key.path;
      };

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
