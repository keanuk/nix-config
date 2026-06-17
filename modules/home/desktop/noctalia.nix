{
  flake.modules.homeManager.noctalia =
    {
      pkgs,
      inputs,
      lib,
      ...
    }:
    {
      programs.noctalia = {
        enable = true;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        systemd.enable = lib.mkDefault true;
        settings = {
          theme = {
            mode = "auto";
            source = "builtin";
            builtin = "Catppuccin";
          };
          location = {
            auto_locate = true;
          };
          # https://docs.noctalia.dev/v5/dock/
          dock = {
            # set true to activate
            enabled = true;
            # top | bottom | left | right
            position = "bottom";
            # when true, only show apps/windows from the active monitor
            active_monitor_only = false;
            icon_size = 48;
            # inner padding along the icon row (main axis)
            main_axis_padding = 16;
            # inner padding perpendicular to the icon row
            cross_axis_padding = 8;
            # gap between items in pixels
            item_spacing = 6;
            background_opacity = 0.8;
            # cast the global [shell.shadow]
            shadow = true;
            radius = 16;
            # optional per-corner overrides
            radius_top_left = 16;
            radius_top_right = 16;
            radius_bottom_left = 16;
            radius_bottom_right = 16;
            # inset from each end of the dock along its main axis
            margin_ends = 0;
            # distance from the nearest screen edge (positive values float the dock)
            margin_edge = 8;
            # also show running apps not in the pinned list
            show_running = true;
            # fade out when pointer leaves; fade in on approach
            auto_hide = true;
            # reserve compositor exclusive zone / push windows away
            reserve_space = true;
            # icon scale for the focused app (clamped 0.1–1.75)
            active_scale = 1.0;
            # icon scale for non-focused apps (clamped 0.1–1.0)
            inactive_scale = 0.85;
            # magnify icons near the pointer (macOS-style)
            magnification = false;
            # max scale multiplier at the pointer center (1.0–2.0; 1.0 = off)
            magnification_scale = 1.35;
            active_opacity = 1.0;
            inactive_opacity = 0.85;
            # badge with window count when an app has 2+ windows
            show_instance_count = true;
            # Desktop entry IDs, StartupWMClass, or human-readable names
            pinned = [
              "firefox"
              "thunderbird"
              "element"
              "halloy"
              "org.gnome.Maps"
              "ente"
              "org.gnome.Nautilus"
              "proton-pass"
              "standardnotes"
              "zed"
              "ghostty"
            ];
          };
          # https://docs.noctalia.dev/v5/bar/
          # layer-shell creation order; names omitted from order are appended after
          bar.order = [ "default" ];
          bar.default = {
            # top | bottom | left | right
            position = "top";
            enabled = true;
            # slide out after pointer leaves; reveal from edge trigger strip
            auto_hide = false;
            # reserve compositor exclusive zone / push windows away
            reserve_space = true;
            # top | overlay; overlay appears above fullscreen apps
            layer = "top";
            # bar cross-axis size in pixels (height for horizontal, width for vertical)
            thickness = 34;
            # 0.0 (transparent) to 1.0 (opaque)
            background_opacity = 0.8;
            # color role or #RRGGBB for the bar outline
            border = "outline";
            # inside outline width in pixels; 0 disables it
            border_width = 0.0;
            # cast the global [shell.shadow]
            shadow = true;
            # dark gradient between an attached panel and the bar (depth at the seam)
            contact_shadow = false;
            # logical px an attached panel overlaps the bar edge to hide the seam
            panel_overlap = 1;
            # global corner radius fallback; per-corner keys override when provided
            radius = 12;
            radius_top_left = 12;
            radius_top_right = 12;
            radius_bottom_left = 12;
            radius_bottom_right = 12;
            # inset from each end of the bar along its main axis
            margin_ends = 180;
            # distance from the nearest screen edge (positive values float the bar)
            margin_edge = 10;
            # main-axis padding from bar edges to start/end widget sections
            padding = 14;
            # gap between widgets within a section
            widget_spacing = 6;
            # content scale multiplier for icons and text
            scale = 1.0;
            # "regular" | "bold" — primary label weight for bar widgets
            font_weight = "regular";
            # typeface for this bar's widgets; empty inherits the global font
            font_family = "";
            # true gives every widget a capsule unless [widget.*] sets capsule = false
            capsule = false;
            # default capsule background color role; fixed hex colors also work
            capsule_fill = "surface_variant";
            # capsule size as a fraction of bar thickness (1.0 fills the bar)
            capsule_thickness = 0.76;
            # omit for automatic pill radius
            capsule_radius = 8.0;
            # capsule background opacity (0.0–1.0)
            capsule_opacity = 1.0;
            # color role for the capsule border; omit this key for no border by default
            # capsule_border = "outline";
            start = [ "workspaces" ];
            center = [ "clock" ];
            end = [
              "volume"
              "battery"
              "bluetooth"
              "network"
              "notifications"
              "control-center"
              "session"
            ];
          };
          # https://docs.noctalia.dev/v5/configuration/shell/
          shell = {
            # undocumented: run launched apps as systemd user services
            launch_apps_as_systemd_services = true;
            # register Noctalia's native polkit authentication agent
            polkit_agent = true;
            # content scale for panels and non-bar shell UI
            ui_scale = 1.0;
            # Pango family string; Fontconfig handles fallback
            font_family = "sans-serif";
            # override language detection; BCP-47 or POSIX locale (empty = follow $LC_ALL/$LC_MESSAGES/$LANG)
            lang = "de";
            # default time format for shell UI without its own setting
            time_format = "{:%H:%M}";
            # default date format for shell UI without its own setting
            date_format = "%A, %x";
            # block all outgoing HTTP requests (weather, community palettes/templates, album art, remote notification icons)
            offline_mode = false;
            # anonymous startup ping to api.noctalia.dev/ping
            telemetry_enabled = true;
            # open first-run wizard while the marker is missing
            setup_wizard_enabled = true;
            # niri-only: type-to-launch from overview
            niri_overview_type_to_launch_enabled = true;
            # default | random — random cycles multiple filled glyph shapes on polkit and lock screen inputs
            password_style = "default";
            avatar_path = "~/Pictures/avatar.png";
            # show advanced settings by default in Settings
            settings_show_advanced = false;
            # middle-click bar widgets to open their Settings entry
            middle_click_opens_widget_settings = true;
            # show weather location text in shell UI
            show_location = true;
            # recolor application icons across the shell (dock, tray, taskbar, active-window, launcher)
            app_icon_colorize = false;
            # ColorSpec when colorize is enabled; color role or #hex
            app_icon_color = "on_surface";
            # false disables clipboard history/panel (basic copy & paste still work)
            clipboard_enabled = true;
            # unpinned history cap (10–10000); pinned entries are exempt
            clipboard_history_max_entries = 100;
            # confirm before clear history / delete unpinned entries
            clipboard_confirm_clear_history = true;
            # off | auto | ctrl_v | ctrl_shift_v | shift_insert
            clipboard_auto_paste = "auto";
            # image clipboard action; e.g. "gimp {path}" or "satty -f -"
            clipboard_image_action_command = "";
            # startup-only; share GPU textures across surfaces (set false for buggy cross-context sharing)
            shared_gl_context = true;

            animation = {
              enabled = true;
              # 1.0 = normal, 0.5 = 2× slower, 2.0 = 2× faster
              speed = 1.0;
            };

            shadow = {
              # center | up | down | left | right | up_left | up_right | down_left | down_right
              direction = "down";
              # multiplied by each component's background opacity
              alpha = 0.55;
            };

            panel = {
              # solid | soft | glass; controls floating/centered opacity and card translucency
              transparency_mode = "soft";
              # outline on floating/centered panel shells and section cards inside panels
              borders = true;
              # cast the global [shell.shadow] from panel surfaces
              shadow = true;
              # attached | floating | centered
              launcher_placement = "centered";
              clipboard_placement = "centered";
              control_center_placement = "attached";
              wallpaper_placement = "attached";
              session_placement = "attached";
              # attached/floating: follow the bar click instead of bar-center
              open_near_click_control_center = false;
              open_near_click_launcher = false;
              open_near_click_clipboard = false;
              open_near_click_wallpaper = false;
              open_near_click_session = false;
              # show launcher category filters; Tab toggles them while open
              launcher_categories = true;
              # show application icons in launcher results
              launcher_show_icons = true;
              # smaller icons and tighter rows; hides subtitles
              launcher_compact = false;
              # include session actions in general search, not only behind /session
              launcher_session_search = false;
              # boost frequently used apps and show Recently Used filter
              launcher_sort_by_usage = true;
            };

            screen_corners = {
              # overlay black rounded corners on each screen
              enabled = false;
              # corner radius in logical pixels (1–100)
              size = 32;
            };

            mpris = {
              # ignore MPRIS players by bus/identity/desktop entry token (case-insensitive substring)
              blacklist = [ ];
            };

            screenshot = {
              # write captures as PNG to the output directory
              save_to_file = true;
              # output folder; empty = ~/Pictures
              directory = "";
              # strftime pattern, no extension (.png is added)
              filename_pattern = "screenshot_%Y%m%d_%H%M%S";
              # also place the PNG on the clipboard (requires clipboard_enabled = true)
              copy_to_clipboard = true;
              # freeze the desktop before region selection
              freeze_screen = false;
              # pipe the PNG to a shell command on stdin
              pipe_to_command = false;
              # annotator/uploader, e.g. "swappy -f -" or "satty -f -"
              pipe_command = "";
            };

            # Omitting [shell.session] entirely keeps the default 5 actions:
            # lock, logout, lock_and_suspend, reboot, shutdown. Add an `actions`
            # list of attrsets to override; an explicit `actions = []` hides all
            # session buttons.
          };

          osd = {
            # top_right | top_left | top_center | bottom_right | bottom_left | bottom_center | center_right | center_left
            position = "top_center";
            # horizontal | vertical
            orientation = "horizontal";
            # OSD size multiplier on top of shell.ui_scale
            scale = 1.0;
            # connector names; omit or leave empty for all monitors
            # monitors = [ "DP-1" ];

            kinds = {
              # master volume OSD toggle (enables both output and input)
              volume = true;
              # output (speaker) volume; requires volume = true
              volume_output = true;
              # input (microphone) volume; requires volume = true
              volume_input = true;
              brightness = true;
              wifi = true;
              bluetooth = true;
              # power profile changes
              power_profile = true;
              # idle inhibitor (caffeine) toggle
              caffeine = true;
              # Do Not Disturb toggle
              dnd = true;
              # Caps/Num/Scroll Lock popups
              lock_keys = true;
              # input keyboard layout changes
              keyboard_layout = true;
            };
          };

          lockscreen = {
            # master switch for session lock
            enabled = true;
            # submit Enter with an empty password (security-key PAM stacks)
            allow_empty_password = false;
            # use a desktop snapshot as the lock screen background (requires wlr-screencopy)
            blurred_desktop = true;
            # background blur (0.0 = none, 1.0 = maximum)
            blur_intensity = 0.5;
            # surface-color tint over the background (0.0 = none, 1.0 = opaque)
            tint_intensity = 0.3;
            # optional image path; empty uses the desktop wallpaper per output
            wallpaper = "";
          };
          # required by Niri's "Option 1: Blurred Overview Wallpaper" setup
          backdrop = {
            enabled = true;
            # 0.0 = no blur, 1.0 = maximum
            blur_intensity = 0.5;
            # 0.0 = no tint, 1.0 = opaque
            tint_intensity = 0.3;
          };

          # chord format: key, modifier+key, or modifier+modifier+key
          # supported modifiers: ctrl, shift, alt (super is rejected)
          keybinds = {
            validate = [
              "return"
              "kp_enter"
            ];
            cancel = [ "escape" ];
            left = [ "left" ];
            right = [ "right" ];
            up = [ "up" ];
            down = [ "down" ];
          };
        };
      };
    };
}
