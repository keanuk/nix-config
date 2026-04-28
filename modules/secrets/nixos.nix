{ config, inputs, ... }:
let
  sopsFile = config._module.args.rootPath + "/secrets/sops/secrets.yaml";
in
{
  flake.modules.nixos.sops =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = sopsFile;
        defaultSopsFormat = "yaml";

        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = lib.mkDefault "${config.users.users.keanu.home}/.config/sops/age/keys.txt";
          generateKey = true;
        };

        secrets.google_maps_geolocation = {
          owner = config.users.users.keanu.name;
        };

        secrets.nextdns_id = {
          mode = "0444";
        };
      };
    };
}
