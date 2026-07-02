{ config, inputs, ... }:
{
  flake.modules.nixos.nixarr =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        inputs.nixarr.nixosModules.default
      ];

      nixarr = {
        enable = true;
        stateDir = lib.mkDefault "/data/.state/nixarr";
        mediaDir = lib.mkDefault "/data/nixarr";
        mediaUsers = [
          "keanu"
        ];

        vpn = {
          enable = true;
          wgConf = lib.mkDefault "/data/.secret/wg.conf";
          accessibleFrom = [
            "10.19.5.0/24"
          ];
        };

        transmission = {
          enable = true;
          package = pkgs.unstable.transmission_4;
          vpn.enable = true;
          peerPort = 51413;
          credentialsFile = lib.mkDefault "/data/.secret/transmission/settings.json";
          extraAllowedIps = [
            "10.19.5.*"
          ];
        };

        plex = {
          enable = true;
          package = pkgs.unstable.plex;
          openFirewall = true;
        };

        jellyfin = {
          enable = true;
          package = pkgs.unstable.jellyfin;
          openFirewall = true;
        };

        seerr = {
          enable = true;
          package = pkgs.unstable.seerr;
        };

        audiobookshelf = {
          enable = true;
          package = pkgs.unstable.audiobookshelf;
          openFirewall = true;
        };

        shelfmark = {
          enable = true;
          package = pkgs.unstable.shelfmark;
          openFirewall = true;
        };

        autobrr = {
          enable = true;
          package = pkgs.unstable.autobrr;
        };

        bazarr = {
          enable = true;
          package = pkgs.unstable.bazarr;
          openFirewall = true;
        };

        lidarr = {
          enable = true;
          package = pkgs.unstable.lidarr;
          openFirewall = true;
        };

        prowlarr = {
          enable = true;
          package = pkgs.unstable.prowlarr;
          openFirewall = true;
        };

        radarr = {
          enable = true;
          package = pkgs.unstable.radarr;
          openFirewall = true;
        };

        sonarr = {
          enable = true;
          package = pkgs.unstable.sonarr;
          openFirewall = true;
        };

        recyclarr = {
          enable = true;
          package = pkgs.unstable.recyclarr;
          schedule = "daily";
          configFile = ./recyclarr.yaml;
        };

        anchorr = {
          enable = false;
          package = pkgs.unstable.anchorr;
          openFirewall = true;
        };
      };

      # Ensure all Nixarr services have access to the media group
      users.users =
        lib.genAttrs
          [
            "transmission"
            "plex"
            "bazarr"
            "lidarr"
            "prowlarr"
            "radarr"
            "recyclarr"
            "sonarr"
          ]
          (_: {
            extraGroups = [ "media" ];
          });

      # Workaround: Plex bundles libdrm 2.4.120 (whose amdgpu.ids path is a
      # Conan build-prefix that doesn't exist inside the bubblewrap sandbox,
      # so VAAPI init fails). Fix: BindReadOnlyPaths mounts the host's
      # amdgpu.ids at the exact Conan path libdrm expects.
      #
      # The host's radeonsi driver can't be dlopen'd into Plex's musl-based
      # process (TLS initial-exec model conflict + glibc 2.42 symbol gaps).
      # Plex's bundled radeonsi (LLVM 16) is used instead — VCN fixed-function
      # hardware encode/decode may still work for H264/HEVC even without
      # full shader compilation support for gfx1201.
      #
      # On hosts with dual AMD GPUs (ursa: dGPU renderD128 + iGPU
      # renderD129), Plex picks the iGPU which can't transcode. A udev rule
      # sets renderD129 mode 0000, but Plex still tries it (EACCES) and gives
      # up without trying renderD128 — it doesn't iterate. So ExecStartPre
      # also deletes renderD129 from /dev/dri/ so Plex only finds renderD128.
      # Safe on headless servers where the iGPU render node isn't used.
      # Last checked: 2026-07-02. Remove when Plex ships libdrm >= 2.4.133
      # and Mesa with RDNA 4 support in its bundled driver set.
      services.udev.extraRules = ''
        SUBSYSTEM=="drm", KERNEL=="renderD129", OWNER="root", GROUP="root", MODE="0000"
      '';
      systemd.services.plex = {
        environment.XDG_CACHE_HOME = "${config.services.plex.dataDir}/Plex Media Server/Cache";
        serviceConfig = {
          MemoryDenyWriteExecute = lib.mkForce false;
          BindReadOnlyPaths = [
            "${pkgs.libdrm}/share/libdrm:/home/runner/_work/plex-conan/plex-conan/.conan/data/libdrm/2.4.120-6/plex/main/build/678777ee2ca8706ca90cf805e0dd88235f6d7f05/meson-install/share/libdrm"
          ];
          ExecStartPre = [
            "+${pkgs.coreutils}/bin/rm -f /dev/dri/renderD129"
            "+${pkgs.writeShellScript "plex-restore-bundled-vaapi-driver" ''
              shopt -s nullglob
              for drv in "${config.services.plex.dataDir}/Plex Media Server/Drivers/"rsv-*/dri/radeonsi_drv_video.so; do
                if [ -L "$drv" ]; then
                  ${pkgs.coreutils}/bin/rm -f "$drv"
                fi
              done
            ''}"
          ];
        };
      };
    };

  flake.modules.nixos.server = config.flake.modules.nixos.nixarr;
}
