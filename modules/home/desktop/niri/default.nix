{ config, inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    # niri is Linux-only; don't define the package on darwin.
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        package = inputs.niri-wm.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        settings = lib.recursiveUpdate (import ./_base-settings.nix) {
          # Window rules and blur follow the upstream recommendations:
          # https://docs.noctalia.dev/v5/compositor-settings/niri/
          window-rules = [
            {
              geometry-corner-radius = 20.0;
              clip-to-geometry = true;
            }
            {
              matches = [ { app-id = "dev.noctalia.Noctalia"; } ];
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

          # Allows notification actions and window activation from noctalia.
          debug.honor-xdg-activation-with-invalid-serial = _: { };

          binds = {
            "Mod+grave".spawn-sh = "noctalia msg panel-toggle launcher";
            "Mod+Space".spawn-sh = "noctalia msg panel-toggle launcher";
            "Mod+E".spawn = "nautilus";
            "Mod+I".spawn-sh = "noctalia msg settings-toggle";
            "Mod+S".spawn-sh = "noctalia msg panel-toggle control-center";
            "Mod+Shift+S".spawn-sh = "noctalia msg panel-toggle wallpaper";
            "Mod+L".spawn-sh = "noctalia msg session lock";
            "Alt+Tab".spawn-sh = "noctalia msg window-switcher";
            "Print".spawn-sh = "noctalia msg screenshot-fullscreen";
            "Shift+Print".spawn-sh = "noctalia msg screenshot-region";
            "XF86AudioRaiseVolume".spawn-sh = "noctalia msg volume-up";
            "XF86AudioLowerVolume".spawn-sh = "noctalia msg volume-down";
            "XF86AudioMute".spawn-sh = "noctalia msg volume-mute";
            "XF86AudioMicMute".spawn-sh = "noctalia msg mic-mute";
            "XF86AudioPlay".spawn-sh = "noctalia msg media toggle";
            "XF86AudioStop".spawn-sh = "noctalia msg media stop";
            "XF86AudioPrev".spawn-sh = "noctalia msg media previous";
            "XF86AudioNext".spawn-sh = "noctalia msg media next";
            "XF86MonBrightnessUp".spawn-sh = "noctalia msg brightness-up";
            "XF86MonBrightnessDown".spawn-sh = "noctalia msg brightness-down";
          };
        };
      };
    };

  flake.modules.homeManager.niri =
    { pkgs, ... }:
    let
      self' = config.perSystem pkgs.stdenv.hostPlatform.system;
    in
    {
      home.packages = with pkgs; [
        blueman
        libnotify
        nautilus
        wev
        wf-recorder
      ];

      home.pointerCursor = {
        enable = true;
        package = pkgs.catppuccin-cursors.mochaBlue;
        name = "catppuccin-mocha-blue-cursors";
        size = 24;
        x11.enable = true;
        gtk.enable = true;
      };

      # The session binary (flake niri from the NixOS module) reads
      # ~/.config/niri/config.kdl; the wrapped package above only generates and
      # validates the shared base config included here.
      # noctalia.kdl is written by noctalia's theme templates when present.
      xdg.configFile."niri/config.kdl".text = ''
        include "${self'.packages.myNiri}/niri-config.kdl"
        include optional=true "noctalia.kdl"
      '';
    };
}
