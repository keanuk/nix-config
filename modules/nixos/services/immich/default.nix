{ config, ... }:
{
  flake.modules.nixos.immich =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      mediaLoc = config.services.immich.mediaLocation;
    in
    {
      services.immich = {
        enable = true;
        package = pkgs.unstable.immich;
        openFirewall = true;
        host = "0.0.0.0";
        port = 2283;
        mediaLocation = lib.mkDefault "/data/immich";
      };

      systemd.tmpfiles.rules = [
        "d ${mediaLoc} 0750 immich immich -"
        "d ${mediaLoc}/encoded-video 0750 immich immich -"
        "d ${mediaLoc}/library 0750 immich immich -"
        "d ${mediaLoc}/profile 0750 immich immich -"
        "d ${mediaLoc}/thumbs 0750 immich immich -"
        "d ${mediaLoc}/upload 0750 immich immich -"
        "d ${mediaLoc}/backups 0750 immich immich -"
        "f ${mediaLoc}/encoded-video/.immich 0640 immich immich -"
        "f ${mediaLoc}/library/.immich 0640 immich immich -"
        "f ${mediaLoc}/profile/.immich 0640 immich immich -"
        "f ${mediaLoc}/thumbs/.immich 0640 immich immich -"
        "f ${mediaLoc}/upload/.immich 0640 immich immich -"
        "f ${mediaLoc}/backups/.immich 0640 immich immich -"
      ];
    };

  flake.modules.nixos.server = config.flake.modules.nixos.immich;
}
