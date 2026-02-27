{ inputs, config, ... }:
{
  imports = [
    ../_mixins/base

    ../_mixins/base/sops.nix
    ../_mixins/darwin
    (import ../_mixins/services/openclaw.nix {
      inherit inputs;
      openclawTelegramTokenFile = config.sops.secrets.openclaw_telegram_bot_token_salacia.path;
      openclawMistralApiKeyFile = config.sops.secrets.openclaw_mistral_api_key.path;
      openclawGatewayTokenFile = config.sops.secrets.openclaw_gateway_token.path;
    })
  ];

  sops.secrets.openclaw_telegram_bot_token_salacia = { };
  sops.secrets.openclaw_mistral_api_key = { };
  sops.secrets.openclaw_gateway_token = { };

  home = {
    username = "keanu";
    homeDirectory = "/Users/keanu";
    stateVersion = "25.11";
  };
}
