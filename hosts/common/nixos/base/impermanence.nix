{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
  
  programs.fuse.userAllowOther = true;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/keanu";
        user = "keanu";
        group = "keanu";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/var/keys/secret_file";
        parentDirectory = {
          mode = "u=rwx,g=,o=";
        };
      }
      {
        file = "/etc/nix/id_rsa";
        parentDirectory = {
          mode = "u=rwx,g=,o=";
        };
      }
    ];
  };
}
