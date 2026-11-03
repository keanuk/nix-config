{ inputs, ... }:
{
  flake.modules.homeManager.umbriel =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      noctaliaEnabled = config.theme.noctaliaManaged;
    in
    {
      imports = [
        inputs.umbriel.homeModules.default
      ];

      home.packages = with pkgs; [
        blueman
        libnotify
        nautilus
        wev
        wf-recorder
      ];

      home.pointerCursor = {
        enable = lib.mkDefault true;
        package = lib.mkDefault pkgs.catppuccin-cursors.mochaDark;
        name = lib.mkDefault "catppuccin-mocha-dark-cursors";
        size = lib.mkDefault 24;
        x11.enable = lib.mkDefault true;
        gtk.enable = lib.mkDefault true;
      };

      programs.umbriel = {
        enable = true;
        settings = {
          # outputs.toml holds per-host monitor settings; noctalia.toml is
          # written by noctalia's theme templates when present.
          include.optional.files = [
            "outputs.toml"
            "noctalia.toml"
          ];

          input = {
            keyboard = {
              layout = "us";
              numlock_toggle = true;
            };
            touchpad = {
              tap = true;
              click_method = "clickfinger";
              natural_scroll = true;
            };
            mouse = {
              natural_scroll = true;
            };
            cursor = {
              theme = "catppuccin-mocha-dark-cursors";
              size = 24;
            };
          };

          layout = {
            mode = "scrolling";
            gap = 8;
            extent_presets = [
              0.333
              0.5
              0.667
            ];
            scrolling = {
              default_extent_fraction = 0.9;
              center_focused = "on_overflow";
            };
          };

          appearance = {
            prefer_no_csd = true;
            border_width = 2;
            corner_radius = 20;
            blur = {
              enabled = true;
              optimized = true;
              passes = 2;
              radius = 3;
              noise = 0.03;
              saturation = 1.0;
            };
          };

          # Static fallback border colors when Noctalia theme templates are not active.
          colors = lib.mkIf (!noctaliaEnabled) {
            border = {
              focused = "#89b4fa";
              unfocused = "#45475a";
            };
          };

          environment = {
            QT_QPA_PLATFORM = "wayland";
            SDL_VIDEODRIVER = "wayland";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            NIXOS_OZONE_WL = "1";
          };

          # Window and layer rules follow the upstream recommendations:
          # https://docs.noctalia.dev/noctalia/compositor-settings/umbriel/
          window_rule = [
            {
              blur = true;
            }
            {
              match.app_id = "^dev.noctalia.Noctalia$";
              default_floating = true;
              default_floating_size_px = {
                width = 1080;
                height = 920;
              };
              opacity = 0.9;
            }
            {
              match.app_id = "^dev.noctalia.UmbrielSharePicker$";
              default_floating = true;
              default_floating_size_px = {
                width = 800;
                height = 600;
              };
            }
            {
              match.title = "^(Picture-in-Picture|Picture in picture)$";
              default_floating = true;
              default_maximize = false;
              default_position = {
                x = 20;
                y = 20;
                anchor = "bottom_right";
              };
            }
            {
              match.title = "^notificationtoasts_.+_desktop";
              default_position = {
                x = 0;
                y = 0;
                anchor = "bottom_right";
              };
              default_focused = false;
              default_pinned = true;
            }
          ];

          layer_rule = [
            {
              match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher|desktop-widget-[^\"]*)$";
              blur = true;
              blur_ignore_alpha = 0.5;
              blur_popups = true;
            }
            {
              match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd|window-switcher)$";
              blur_optimized = false;
            }
          ];

          hot_corners.top_left = {
            enabled = true;
            delay_ms = 500;
            action = "overview-open";
          };

          keybinds = {
            # Applications and session
            "Mod+Return" = {
              action = "spawn alacritty";
              repeat = false;
            };
            "Mod+E" = {
              action = "spawn nautilus";
              repeat = false;
            };
            "Mod+Q" = {
              action = "window-close";
              repeat = false;
            };
            "Mod+Shift+Q" = "session-quit";
            "Mod+Escape" = "session-quit";
            "Mod+Shift+Escape" = {
              action = "shortcuts-inhibit-toggle";
              allow_when_inhibited = true;
              repeat = false;
            };

            # Noctalia shell
            "Mod+grave" = {
              action = "spawn noctalia msg panel-toggle launcher";
              repeat = false;
            };
            "Mod+Space" = {
              action = "spawn noctalia msg panel-toggle launcher";
              repeat = false;
            };
            "Alt+Space" = {
              action = "spawn noctalia msg panel-toggle launcher";
              repeat = false;
            };
            "Mod+I" = {
              action = "spawn noctalia msg settings-toggle";
              repeat = false;
            };
            "Mod+S" = {
              action = "spawn noctalia msg panel-toggle control-center";
              repeat = false;
            };
            "Mod+Shift+S" = {
              action = "spawn noctalia msg panel-toggle wallpaper";
              repeat = false;
            };
            "Mod+L" = {
              action = "spawn noctalia msg session lock";
              repeat = false;
            };
            "Alt+Tab" = "spawn noctalia msg window-switcher";
            "Print" = {
              action = "spawn noctalia msg screenshot-fullscreen";
              repeat = false;
            };
            "Shift+Print" = {
              action = "spawn noctalia msg screenshot-region";
              repeat = false;
            };

            # Ploopy A+ Trackball buttons: the macOS Mission Control/Launchpad
            # usages are remapped to KEY_PROG1/KEY_PROG2 (keysyms
            # XF86Launch1/XF86Launch2) by the hwdb rule in
            # modules/nixos/services/udev.
            "XF86Launch1" = {
              action = "overview-toggle";
              repeat = false;
            };
            "XF86Launch2" = {
              action = "spawn noctalia msg panel-toggle launcher";
              repeat = false;
            };

            # Media, volume, and brightness
            "XF86AudioRaiseVolume" = {
              action = "spawn noctalia msg volume-up";
              allow_when_locked = true;
            };
            "XF86AudioLowerVolume" = {
              action = "spawn noctalia msg volume-down";
              allow_when_locked = true;
            };
            "XF86AudioMute" = {
              action = "spawn noctalia msg volume-mute";
              allow_when_locked = true;
              repeat = false;
            };
            "XF86AudioMicMute" = {
              action = "spawn noctalia msg mic-mute";
              allow_when_locked = true;
              repeat = false;
            };
            "XF86AudioPlay" = {
              action = "spawn noctalia msg media toggle";
              allow_when_locked = true;
              repeat = false;
            };
            "XF86AudioStop" = {
              action = "spawn noctalia msg media stop";
              allow_when_locked = true;
              repeat = false;
            };
            "XF86AudioPrev" = {
              action = "spawn noctalia msg media previous";
              allow_when_locked = true;
            };
            "XF86AudioNext" = {
              action = "spawn noctalia msg media next";
              allow_when_locked = true;
            };
            "XF86MonBrightnessUp" = {
              action = "spawn noctalia msg brightness-up";
              allow_when_locked = true;
            };
            "XF86MonBrightnessDown" = {
              action = "spawn noctalia msg brightness-down";
              allow_when_locked = true;
            };

            # Window state and layout
            "Mod+F" = {
              action = "window-toggle-fullscreen";
              repeat = false;
            };
            "Mod+Shift+F" = {
              action = "window-toggle-maximize";
              repeat = false;
            };
            "Mod+M" = {
              action = "window-toggle-maximize-to-edges";
              repeat = false;
            };
            "Mod+C" = "column-center";
            "Mod+Shift+Space" = {
              action = "window-toggle-floating";
              repeat = false;
            };
            "Mod+T" = {
              action = "window-toggle-floating";
              repeat = false;
            };
            "Mod+Shift+T" = {
              action = "window-focus-switch-floating";
              repeat = false;
            };
            "Mod+P" = {
              action = "window-toggle-pinned";
              repeat = false;
            };
            "Mod+R" = "window-cycle-primary-extent";
            "Mod+Shift+R" = "window-cycle-primary-extent-back";
            "Mod+Ctrl+Comma" = "window-consume-from-left";
            "Mod+Ctrl+Period" = "window-consume-from-right";
            "Mod+W" = {
              action = "column-toggle-tabbed";
              repeat = false;
            };
            "Mod+Alt+Right" = "column-focus-tab-next";
            "Mod+Alt+Left" = "column-focus-tab-previous";
            "Mod+O" = {
              action = "overview-toggle";
              repeat = false;
            };

            # Focus and movement
            "Mod+Left" = "window-focus-left";
            "Mod+Right" = "window-focus-right";
            "Mod+Up" = "window-focus-up";
            "Mod+Down" = "window-focus-down";
            "Mod+H" = "window-focus-left";
            "Mod+J" = "window-focus-down";
            "Mod+K" = "window-focus-up";
            "Mod+WheelUp" = "window-focus-left";
            "Mod+WheelDown" = "window-focus-right";
            "Mod+Shift+Left" = "column-move-left";
            "Mod+Shift+Right" = "column-move-right";
            "Mod+Shift+Up" = "window-move-up";
            "Mod+Shift+Down" = "window-move-down";

            # Workspaces
            "Mod+Comma" = "workspace-previous";
            "Mod+Period" = "workspace-next";
            "Mod+Ctrl+Up" = "workspace-previous";
            "Mod+Ctrl+Down" = "workspace-next";
            "Mod+Shift+Comma" = "column-move-to-workspace-previous";
            "Mod+Shift+Period" = "column-move-to-workspace-next";
            "Mod+Ctrl+Shift+Up" = "column-move-to-workspace-previous";
            "Mod+Ctrl+Shift+Down" = "column-move-to-workspace-next";
            "Mod+1" = "workspace-switch 1";
            "Mod+2" = "workspace-switch 2";
            "Mod+3" = "workspace-switch 3";
            "Mod+4" = "workspace-switch 4";
            "Mod+5" = "workspace-switch 5";
            "Mod+6" = "workspace-switch 6";
            "Mod+7" = "workspace-switch 7";
            "Mod+8" = "workspace-switch 8";
            "Mod+9" = "workspace-switch 9";
            "Mod+0" = "workspace-switch 10";
            "Mod+Shift+1" = "column-move-to-workspace 1";
            "Mod+Shift+2" = "column-move-to-workspace 2";
            "Mod+Shift+3" = "column-move-to-workspace 3";
            "Mod+Shift+4" = "column-move-to-workspace 4";
            "Mod+Shift+5" = "column-move-to-workspace 5";
            "Mod+Shift+6" = "column-move-to-workspace 6";
            "Mod+Shift+7" = "column-move-to-workspace 7";
            "Mod+Shift+8" = "column-move-to-workspace 8";
            "Mod+Shift+9" = "column-move-to-workspace 9";
            "Mod+Shift+0" = "column-move-to-workspace 10";
          };
        };
      };
    };
}
