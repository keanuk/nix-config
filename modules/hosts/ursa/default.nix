{ config, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    amd
    hardware
    server
    lanzaboote
    btrfs
    ollama-medium
    ollama-high
    keanu
    home-manager-stable
    github-runner
    harmonia
    ;
in
{
  configurations.nixos-stable.ursa.module =
    { lib, ... }:
    {
      imports = [
        base
        amd
        hardware
        server
        lanzaboote
        btrfs
        ollama-medium
        ollama-high
        keanu
        home-manager-stable
        github-runner
        harmonia
        ./_disko-btrfs.nix
        ./_hardware-configuration.nix
        ./_raid-configuration.nix
        ./_shares.nix
        ./_github-runner.nix
      ];

      # Every service that needs /data waits for the RAID array to come online
      # first and cleanly stops before /data unmounts on shutdown.
      systemd.services =
        lib.genAttrs
          [
            "immich-server"
            "immich-machine-learning"
            "nextcloud-setup"
            "nextcloud-cron"
            "phpfpm-nextcloud"
            "forgejo"
            "home-assistant"
            "autobrr"
            "transmission"
            "plex"
            "jellyfin"
            "seerr"
            "audiobookshelf"
            "shelfmark"
            "bazarr"
            "lidarr"
            "prowlarr"
            "radarr"
            "recyclarr"
            "sonarr"
            "wg"
          ]
          (_: {
            after = [ "raid-online.target" ];
            requires = [ "raid-online.target" ];
            unitConfig = {
              AssertPathIsMountPoint = "/data";
              RequiresMountsFor = "/data";
            };
          });

      services.nextcloud = {
        hostName = "ursa";
        home = "/data/.state/nextcloud";
        datadir = "/data/nextcloud";
        settings.trusted_domains = [
          "ursa"
          "localhost"
          "ursa.local"
          "10.19.5.10"
          "100.91.10.104"
          "192.168.15.5"
          "${config.domains.services.cloud.subdomain}.${config.domains.primary}"
        ];
      };

      # RX 9070 XT is RDNA 4 (Navi 48, gfx1201). Update if upstream ollama-rocm
      # ships a different override for this part.
      services.ollama.rocmOverrideGfx = lib.mkForce "12.0.1";

      nixpkgs.hostPlatform = "x86_64-linux";
      networking = {
        hostName = "ursa";
        useDHCP = lib.mkForce false;
        interfaces.enp13s0.ipv4.addresses = [
          {
            address = "10.19.5.10";
            prefixLength = 24;
          }
        ];
        defaultGateway = "10.19.5.1";
        nameservers = [ "10.19.5.1" ];
      };

      system.stateVersion = "26.05";
    };
}
