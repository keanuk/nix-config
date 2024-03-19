{ inputs, config, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../../../../secrets/sops/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/keanu/.config/sops/age/keys.txt";

  sops.secrets.google_maps_geolocation = {
    owner = config.users.users.keanu.name;
  };
}
