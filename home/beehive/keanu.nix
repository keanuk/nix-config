{ inputs, ... }:
{
  imports = [
    ../_mixins/base
    ../_mixins/base/home-manager.nix
    ../_mixins/base/server.nix
    ../_mixins/desktop/pass
    (import ../_mixins/services/openclaw {
      inherit inputs;
      openclawTelegramTokenFile = "/run/secrets/openclaw_telegram_bot_token_beehive";
      openclawMistralApiKeyFile = "/run/secrets/openclaw_mistral_api_key";
      openclawGatewayTokenFile = "/run/secrets/openclaw_gateway_token";
      openclawOpenaiApiKeyFile = "/run/secrets/openclaw_openai_api_key";
    })
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.05";
  };
}
