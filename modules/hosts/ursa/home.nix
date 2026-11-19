{ config, ... }:
{
  configurations.nixos-stable.ursa.homeUsers.keanu = {
    imports = with config.flake.modules.homeManager; [
      base
      server
      hermes
    ];

    programs.hermesSecrets = {
      telegramTokenFile = "/run/secrets/hermes_telegram_bot_token_ursa";
      openaiApiKeyFile = "/run/secrets/hermes_openai_api_key";
      primaryModel = "ollama/mistral-small3.2";
    };

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
      stateVersion = "26.05";
    };
  };
}
