{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets/sops/secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      # This will automatically import the SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # This is the user's age key, but it might not be available during activation
      # if the user's home directory is on a filesystem that hasn't been mounted yet.
      keyFile = lib.mkDefault "${config.users.users.keanu.home}/.config/sops/age/keys.txt";
      # Fallback to the standard sops-nix key file if it exists
      generateKey = true;
    };

    secrets.google_maps_geolocation = {
      owner = config.users.users.keanu.name;
    };

    secrets.nextdns_id = {
      mode = "0444";
    };
  };
}
