{ config, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      niriPkg = inputs.niri-wm.packages.${pkgs.stdenv.hostPlatform.system}.niri or pkgs.hello;
      baseSettings = import ../niri/_base-settings.nix;
    in
    {
      packages.myNiriMinimal = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        package = niriPkg;
        settings = lib.recursiveUpdate baseSettings {
          spawn-at-startup = [
            "systemctl --user start graphical-session.target"
            (lib.getExe self'.packages.myNoctalia)
          ];

          window-rules = [
            {
              geometry-corner-radius = 20.0;
              clip-to-geometry = true;
            }
            {
              matches = [ { app-id = "dev.noctalia.Noctalia.Settings"; } ];
              default-column-width.fixed = 1080;
              default-window-height.fixed = 920;
              open-floating = true;
            }
            {
              background-effect = {
                blur = true;
                xray = false;
              };
            }
          ];

          layer-rules = [
            {
              matches = [ { namespace = "^noctalia-backdrop"; } ];
              place-within-backdrop = true;
            }
            {
              matches = [
                {
                  namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
                }
              ];
              background-effect.xray = false;
            }
          ];

          blur = {
            passes = 2;
            offset = 3.0;
            noise = 0.03;
            saturation = 1.0;
          };

          debug.honor-xdg-activation-with-invalid-serial = _: { };

          binds = {
            "Mod+grave".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle launcher";
            "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle launcher";
            "Mod+E".spawn = "nautilus";
            "Mod+I".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg settings-toggle";
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle control-center";
            "Mod+Shift+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle wallpaper";
            "Mod+L".spawn = "hyprlock";
            "Alt+Tab".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg window-switcher";
            "Print".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg screenshot-fullscreen";
            "Shift+Print".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg screenshot-region";
            "XF86AudioRaiseVolume".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg volume-up";
            "XF86AudioLowerVolume".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg volume-down";
            "XF86AudioMute".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg volume-mute";
            "XF86AudioMicMute".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg mic-mute";
            "XF86AudioPlay".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg media toggle";
            "XF86AudioStop".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg media stop";
            "XF86AudioPrev".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg media previous";
            "XF86AudioNext".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg media next";
            "XF86MonBrightnessUp".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg brightness-up";
            "XF86MonBrightnessDown".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg brightness-down";
          };
        };
      };
    };

  flake.modules.homeManager.niri-minimal =
    {
      pkgs,
      ...
    }:
    let
      self' = config.perSystem pkgs.stdenv.hostPlatform.system;
    in
    {
      home = {
        packages = with pkgs; [
          blueman
          brightnessctl
          grim
          libnotify
          nautilus
          pamixer
          playerctl
          slurp
          wev
          wf-recorder
          self'.packages.myNiriMinimal
        ];

        pointerCursor = {
          package = pkgs.catppuccin-cursors.mochaBlue;
          name = "catppuccin-mocha-blue-cursors";
          size = 24;
          x11.enable = true;
          gtk.enable = true;
        };
      };
    };
}
