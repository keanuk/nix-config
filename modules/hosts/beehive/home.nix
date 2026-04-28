{ config, ... }:
let
  beehiveKeanuHome = {
    imports = with config.flake.modules.homeManager; [
      base
      home-manager-self
      server
      pass
      openclaw
    ];

    programs.openclawSecrets = {
      telegramTokenFile = "/run/secrets/openclaw_telegram_bot_token_beehive";
      mistralApiKeyFile = "/run/secrets/openclaw_mistral_api_key";
      gatewayTokenFile = "/run/secrets/openclaw_gateway_token";
      openaiApiKeyFile = "/run/secrets/openclaw_openai_api_key";
      primaryModel = "ollama/gemma4:latest";
      fallbackModels = [
        "ollama/magistral:latest"
        "ollama/qwen3:latest"
      ];
    };

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
      stateVersion = "25.05";
    };
  };
in
{
  configurations.nixos.beehive.module.home-manager.users.keanu = beehiveKeanuHome;

  configurations.homeManager."keanu@beehive" = {
    system = "x86_64-linux";
    module = beehiveKeanuHome;
  };
}
