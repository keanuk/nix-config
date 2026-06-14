{ pkgs, ... }:
{
  home.file.".config/niri/config.kdl".text =
    let
      screenshotScript = pkgs.writeShellScript "niri-screenshot" ''
        set -euo pipefail
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
        ${pkgs.libnotify}/bin/notify-send -i camera-photo "Screenshot" "Screenshot copied to clipboard."
      '';
      screenshotFullScript = pkgs.writeShellScript "niri-screenshot-full" ''
        set -euo pipefail
        ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy
        ${pkgs.libnotify}/bin/notify-send -i camera-photo "Screenshot" "Screenshot copied to clipboard."
      '';
    in
    ''
      // Minimal Niri configuration for Noctalia

      input {
          keyboard { xkb { layout "us" } }
          touchpad { tap; natural-scroll; }
      }

      output "*" { scale 1.0 }

      layout {
          gaps 8
          border { width 2; active "#89b4fa"; inactive "#45475a" }
          focus-ring { width 4; active "#89b4fa"; inactive "#45475a" }
          default-column-width { proportion 0.5 }
          center-focused-column "on-overflow"
      }

      spawn-at-startup "systemctl" "--user" "start" "graphical-session.target"

      environment {
          QT_QPA_PLATFORM "wayland"
          SDL_VIDEODRIVER "wayland"
          _JAVA_AWT_WM_NONREPARENTING "1"
          NIXOS_OZONE_WL "1"
      }

      binds {
          Mod { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
          Mod+Return { spawn "alacritty"; }
          Mod+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
          Mod+Q repeat=false { close-window; }
          Mod+Shift+Q repeat=false { quit; }
          Mod+L { spawn "hyprlock"; }
          Mod+S { spawn "${screenshotScript}"; }
          Mod+Shift+S { spawn "${screenshotFullScript}"; }
          Mod+F { fullscreen-window; }
          Mod+Shift+F { maximize-column; }
          Mod+C { center-column; }
          Mod+Shift+Space { toggle-window-floating; }
          Mod+Left { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Up { focus-window-up; }
          Mod+Down { focus-window-down; }
          Mod+Shift+Left { move-column-left; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+Up { move-window-up; }
          Mod+Shift+Down { move-window-down; }
          Mod+Comma { focus-workspace-up; }
          Mod+Period { focus-workspace-down; }
          Mod+Shift+Comma { move-column-to-workspace-up; }
          Mod+Shift+Period { move-column-to-workspace-down; }
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+0 { focus-workspace 10; }
          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+Shift+6 { move-column-to-workspace 6; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+Shift+9 { move-column-to-workspace 9; }
          Mod+Shift+0 { move-column-to-workspace 10; }
      }
    '';
}
