{
  configurations.nixos.beehive.module =
    { config, ... }:
    {
      sops.secrets = {
        openclaw_telegram_bot_token_beehive = {
          owner = config.users.users.keanu.name;
        };
        openclaw_mistral_api_key = {
          owner = config.users.users.keanu.name;
        };
        openclaw_gateway_token = {
          owner = config.users.users.keanu.name;
        };
        openclaw_openai_api_key = {
          owner = config.users.users.keanu.name;
        };
      };
    };
}
