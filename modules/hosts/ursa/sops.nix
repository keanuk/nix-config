{
  configurations.nixos-stable.ursa.module =
    { config, ... }:
    {
      sops.secrets = {
        openclaw_telegram_bot_token_ursa = {
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
        ursa_raid_password = { };
        github-runner-token = { };
      };
    };
}
