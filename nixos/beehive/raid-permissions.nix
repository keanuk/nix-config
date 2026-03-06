{ pkgs, ... }:
{
  systemd.services.raid-permissions = {
    description = "Fix permissions for all RAID-hosted services";
    after = [ "raid-online.target" ];
    requires = [ "raid-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.systemd}/bin/systemd-tmpfiles --create --prefix=/data";
    };
  };

  # Centralized permission management for the RAID
  systemd.tmpfiles.rules = [
    # RAID Root
    "d /data 0775 root media -"

    # Nixarr services
    "Z /data/.state/nixarr/plex 0750 plex media -"
    "Z /data/.state/nixarr/sonarr 0750 sonarr media -"
    "Z /data/.state/nixarr/prowlarr 0750 prowlarr media -"
    "Z /data/.state/nixarr/bazarr 0750 bazarr media -"
    "Z /data/.state/nixarr/radarr 0750 radarr media -"
    "Z /data/.state/nixarr/lidarr 0750 lidarr media -"
    "Z /data/.state/nixarr/autobrr 0750 autobrr media -"
    "Z /data/.state/nixarr/recyclarr 0750 recyclarr media -"
    "Z /data/.state/nixarr/transmission 0750 transmission media -"

    # Non-Nixarr services
    "Z /data/.state/forgejo 0750 forgejo forgejo -"
    "Z /data/.state/nextcloud 0750 nextcloud nextcloud -"
    "Z /data/.state/home-assistant 0750 hass hass -"
    "Z /data/immich 0750 immich immich -"
    "Z /data/nextcloud 0750 nextcloud nextcloud -"
  ];
}
