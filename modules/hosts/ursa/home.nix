{ config, ... }:
let
  keanuHome = {
    imports = with config.flake.modules.homeManager; [
      base
      home-manager-self
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
in
{
  configurations.nixos-stable.ursa.module.home-manager.users.keanu = keanuHome;

  configurations.homeManager-stable."keanu@ursa" = {
    system = "x86_64-linux";
    module = keanuHome;
  };
}
