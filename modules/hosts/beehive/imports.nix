{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    base
    amd
    hardware
    server
    systemd-boot
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
  configurations.nixos-stable.beehive.module =
    { lib, ... }:
    {
      imports = [
        base
        amd
        hardware
        server
        systemd-boot
        btrfs
        ollama
        ollama-full
        keanu
        home-manager-stable
        github-runner
        harmonia
        system-packages
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        ./_hardware-configuration.nix
        ./_disko-configuration.nix
        ./_raid-configuration.nix
        ./_shares.nix
        ./_github-runner.nix
      ];

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
        hostName = "beehive";
        home = "/data/.state/nextcloud";
        datadir = "/data/nextcloud";
        settings.trusted_domains = [
          "beehive"
          "localhost"
          "beehive.local"
          "10.19.5.10"
          "100.91.10.104"
          "192.168.15.5"
          "cloud.oranos.org"
        ];
      };

      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "beehive";

      system.stateVersion = "25.05";
    };
}
