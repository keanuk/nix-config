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
    in
    {
      packages.myNiriMinimal = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        package = niriPkg;
        settings = {
          input = {
            keyboard.xkb.layout = "us";
            touchpad = {
              tap = _: { };
              natural-scroll = _: { };
            };
          };

          outputs = {
            "*" = {
              scale = 1.0;
            };
          };

          layout = {
            gaps = 8;
            border = {
              width = 2;
              active-color = "#89b4fa";
              inactive-color = "#45475a";
            };
            focus-ring = {
              width = 4;
              active-color = "#89b4fa";
              inactive-color = "#45475a";
            };
            default-column-width.proportion = 0.5;
            center-focused-column = "on-overflow";
          };

          spawn-at-startup = [
            "systemctl --user start graphical-session.target"
            (lib.getExe self'.packages.myNoctalia)
          ];

          environment = {
            QT_QPA_PLATFORM = "wayland";
            SDL_VIDEODRIVER = "wayland";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            NIXOS_OZONE_WL = "1";
          };

          window-rules = [
            {
              geometry-corner-radius = {
                top-left = 20.0;
                top-right = 20.0;
                bottom-left = 20.0;
                bottom-right = 20.0;
              };
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
            "Mod+Return".spawn = "alacritty";
            "Mod+grave".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle launcher";
            "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle launcher";
            "Mod+E".spawn = "nautilus";
            "Mod+I".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg settings-toggle";
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle control-center";
            "Mod+Shift+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle wallpaper";
            "Mod+Q".close-window = _: { };
            "Mod+Shift+Q".quit = _: { };
            "Mod+L".spawn = "hyprlock";
            "Mod+F".fullscreen-window = _: { };
            "Mod+Shift+F".maximize-column = _: { };
            "Mod+C".center-column = _: { };
            "Mod+Shift+Space".toggle-window-floating = _: { };
            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Down".focus-window-down = _: { };
            "Mod+Shift+Left".move-column-left = _: { };
            "Mod+Shift+Right".move-column-right = _: { };
            "Mod+Shift+Up".move-window-up = _: { };
            "Mod+Shift+Down".move-window-down = _: { };
            "Mod+Comma".focus-workspace-up = _: { };
            "Mod+Period".focus-workspace-down = _: { };
            "Mod+Shift+Comma".move-column-to-workspace-up = _: { };
            "Mod+Shift+Period".move-column-to-workspace-down = _: { };
            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;
            "Mod+0".focus-workspace = 10;
            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;
            "Mod+Shift+5".move-column-to-workspace = 5;
            "Mod+Shift+6".move-column-to-workspace = 6;
            "Mod+Shift+7".move-column-to-workspace = 7;
            "Mod+Shift+8".move-column-to-workspace = 8;
            "Mod+Shift+9".move-column-to-workspace = 9;
            "Mod+Shift+0".move-column-to-workspace = 10;
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
