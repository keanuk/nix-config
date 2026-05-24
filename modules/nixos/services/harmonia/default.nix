{ inputs, ... }:
{
  flake.modules.nixos.harmonia =
    { config, ... }:
    {
      imports = [ inputs.harmonia.nixosModules.harmonia ];

      sops.secrets.harmonia-signing-key = {
        mode = "0400";
      };

      services.harmonia-dev.cache = {
        enable = true;
        signKeyPaths = [ config.sops.secrets.harmonia-signing-key.path ];
        settings.bind = "127.0.0.1:5000";
      };

      nix.settings.allowed-users = [ "harmonia" ];
      nix.settings.trusted-users = [ "harmonia" ];
    };
}
