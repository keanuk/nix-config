{
  configurations.nixos-stable.ursa.module =
    { config, ... }:
    {
      sops.secrets = {
        hermes_telegram_bot_token_ursa = {
          owner = config.users.users.keanu.name;
        };
        hermes_openai_api_key = {
          owner = config.users.users.keanu.name;
        };
        ursa_raid_password = {
          mode = "0400";
        };
      };
    };
}
