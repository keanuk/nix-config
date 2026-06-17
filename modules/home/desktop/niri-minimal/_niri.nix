_: {
  home.file.".config/niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
    }

    output "*" {
        scale 1.0
    }

    layout {
        gaps 8
        border {
            width 2
            active-color "#89b4fa"
            inactive-color "#45475a"
        }
        focus-ring {
            width 4
            active-color "#89b4fa"
            inactive-color "#45475a"
        }
        default-column-width { proportion 0.5; }
        center-focused-column "on-overflow"
    }

    spawn-at-startup "systemctl" "--user" "start" "graphical-session.target"
    spawn-at-startup "noctalia"

    environment {
        QT_QPA_PLATFORM "wayland"
        SDL_VIDEODRIVER "wayland"
        _JAVA_AWT_WM_NONREPARENTING "1"
        NIXOS_OZONE_WL "1"
    }

    // Rounded corners + floating settings window
    window-rule {
        geometry-corner-radius 20.0 20.0 20.0 20.0
        clip-to-geometry true
    }
    window-rule {
        match app-id="dev.noctalia.Noctalia.Settings"
        default-column-width { fixed 1080; }
        default-window-height { fixed 920; }
        open-floating true
    }

    // Option 1: Blurred Overview Wallpaper (requires [backdrop] enabled in Noctalia config)
    layer-rule {
        match namespace="^noctalia-backdrop"
        place-within-backdrop true
    }

    // Blur all app windows without xray
    window-rule {
        background-effect {
            blur true
            xray false
        }
    }

    // Disable xray on Noctalia surfaces; uncomment `blur false` to fully disable blur
    layer-rule {
        match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
        background-effect {
            xray false
            // blur false
        }
    }

    // Global blur effect tuning
    blur {
        passes 2
        offset 3.0
        noise 0.03
        saturation 1.0
    }

    // Notification actions / window activation from Noctalia
    debug {
        honor-xdg-activation-with-invalid-serial
    }

    binds {
        Mod+Return { spawn "alacritty"; }
        Mod+grave { spawn-sh "noctalia msg panel-toggle launcher"; }
        Mod+Space { spawn-sh "noctalia msg panel-toggle launcher"; }
        Mod+E { spawn "nautilus"; }
        Mod+I { spawn-sh "noctalia msg settings-toggle"; }
        Mod+S { spawn-sh "noctalia msg panel-toggle control-center"; }
        Mod+Shift+S { spawn-sh "noctalia msg panel-toggle wallpaper"; }
        Mod+Q repeat=false { close-window; }
        Mod+Shift+Q repeat=false { quit; }
        Mod+L { spawn "hyprlock"; }
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
        Alt+Tab { spawn-sh "noctalia msg window-switcher"; }
        Print { spawn-sh "noctalia msg screenshot-fullscreen"; }
        Shift+Print { spawn-sh "noctalia msg screenshot-region"; }
        XF86AudioRaiseVolume { spawn-sh "noctalia msg volume-up"; }
        XF86AudioLowerVolume { spawn-sh "noctalia msg volume-down"; }
        XF86AudioMute { spawn-sh "noctalia msg volume-mute"; }
        XF86AudioMicMute { spawn-sh "noctalia msg mic-mute"; }
        XF86AudioPlay { spawn-sh "noctalia msg media toggle"; }
        XF86AudioStop { spawn-sh "noctalia msg media stop"; }
        XF86AudioPrev { spawn-sh "noctalia msg media previous"; }
        XF86AudioNext { spawn-sh "noctalia msg media next"; }
        XF86MonBrightnessUp { spawn-sh "noctalia msg brightness-up"; }
        XF86MonBrightnessDown { spawn-sh "noctalia msg brightness-down"; }
    }
  '';
}
