{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    amd
    hardware
    server
    lanzaboote
    btrfs
    ollama
    ollama-full
    keanu
    home-manager-stable
    github-runner
    harmonia
    system-packages
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
        ollama
        ollama-full
        keanu
        home-manager-stable
        github-runner
        harmonia
        system-packages
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-pc
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        ./_disko-btrfs.nix
        ./_hardware-configuration.nix
        ./_raid-configuration.nix
        ./_shares.nix
        ./_github-runner.nix
      ];

      # Mirror beehive's per-service ordering: every service that needs
      # /data waits for the RAID array to come online first.
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
            "gitlab"
            "gitlab-workhorse"
            "gitlab-sidekiq"
            "gitaly"
            "transmission"
            "plex"
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
            unitConfig.AssertPathIsMountPoint = "/data";
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
          "cloud.oranos.org"
        ];
      };

      # RX 9070 XT is RDNA 4 (Navi 48, gfx1201). Update if upstream ollama-rocm
      # ships a different override for this part.
      services.ollama.rocmOverrideGfx = lib.mkForce "12.0.1";

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "ursa";

      system.stateVersion = "26.05";
    };
}
