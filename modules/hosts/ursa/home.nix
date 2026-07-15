{ config, lib, ... }:
let
  ursaKeanuHome = {
    imports = with config.flake.modules.homeManager; [
      base
      home-manager-self
      server
      pass
      openclaw
    ];

    programs.openclawSecrets = {
      telegramTokenFile = lib.mkForce "/run/secrets/openclaw_telegram_bot_token_ursa";
      primaryModel = lib.mkForce "ollama/gpt-oss:latest";
      fallbackModels = lib.mkForce [
        "ollama/mistral:latest"
        "ollama/gemma4:latest"
      ];
    };

    home = {
      username = "keanu";
      homeDirectory = "/home/keanu";
      stateVersion = "26.05";
    };
  };
in
{
  configurations.nixos-stable.ursa.module.home-manager.users.keanu = ursaKeanuHome;

  configurations.homeManager-stable."keanu@ursa" = {
    system = "x86_64-linux";
    module = ursaKeanuHome;
  };
}
