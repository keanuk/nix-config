{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets/sops/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "${config.users.users.keanu.home}/.config/sops/age/keys.txt";

    secrets.google_maps_geolocation = {
      owner = config.users.users.keanu.name;
    };

    secrets.nextdns_id = {
      mode = "0444";
    };
  };

  systemd.services.sops-install-secrets = {
    description = "Install sops-nix secrets";
    wantedBy = [ "multi-user.target" ];
    before = [ "mount-raid.service" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = config.system.activationScripts.setupSecrets.text;
  };
}
