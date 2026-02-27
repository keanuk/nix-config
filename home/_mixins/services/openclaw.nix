# OpenClaw AI assistant gateway configuration
#
# This mixin configures nix-openclaw with Telegram + Mistral AI.
# Each host must pass the secret file paths via module arguments.
#
# Required args:
#   openclawTelegramTokenFile - path to Telegram bot token file
#   openclawMistralApiKeyFile - path to Mistral API key file
#   openclawGatewayTokenFile  - path to gateway auth token file
{
  inputs,
  openclawTelegramTokenFile,
  openclawMistralApiKeyFile,
  openclawGatewayTokenFile,
  ...
}:
{
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;

    config = {
      gateway = {
        mode = "local";
        auth = {
          tokenFile = openclawGatewayTokenFile;
        };
      };

      channels.telegram = {
        tokenFile = openclawTelegramTokenFile;
        allowFrom = [ 15634717 ];
        groups = {
          "*" = {
            requireMention = true;
          };
        };
      };

      env.vars = {
        MISTRAL_API_KEY = openclawMistralApiKeyFile;
      };
    };
  };
}
