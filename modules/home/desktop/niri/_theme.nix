{
  pkgs,
  lib,
  ...
}:

{
  xdg.configFile."darkman/config.yaml".text = ''
    usegeoclue: true
    portal: true
    dbusserver: true
  '';

  home.file = {
    # Swaync themes
    ".config/swaync/themes/dark.css".text = ''
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;
      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color blue      #89b4fa;
      @define-color red       #f38ba8;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;

      * {
        font-family: "Roboto", "Noto Color Emoji";
        font-size: 14px;
      }

      .notification {
        background-color: @surface0;
        border: 1px solid @surface1;
        border-radius: 12px;
        padding: 12px;
        margin: 6px;
      }

      .notification-content {
        color: @text;
      }

      .summary {
        font-weight: bold;
        color: @text;
      }

      .body {
        color: @subtext0;
      }

      .control-center {
        background-color: @base;
        border: 1px solid @surface1;
        border-radius: 16px;
        padding: 16px;
      }

      .widget-title {
        color: @text;
        font-weight: bold;
        font-size: 16px;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button {
        background-color: @surface0;
        color: @text;
        border-radius: 8px;
        padding: 8px;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background-color: @surface1;
      }

      .widget-volume {
        background-color: @surface0;
        border-radius: 8px;
        padding: 8px;
      }

      .widget-volume trough {
        background-color: @surface1;
        border-radius: 4px;
        min-height: 8px;
      }

      .widget-volume trough highlight {
        background-color: @blue;
        border-radius: 4px;
      }

      .widget-dnd {
        color: @text;
      }
    '';

    ".config/swaync/themes/light.css".text = ''
      @define-color base   #eff1f5;
      @define-color mantle #e6e9ef;
      @define-color crust  #dce0e8;
      @define-color text     #4c4f69;
      @define-color subtext0 #6c6f85;
      @define-color surface0 #ccd0da;
      @define-color surface1 #bcc0cc;
      @define-color blue      #1e66f5;
      @define-color red       #d20f39;
      @define-color green     #40a02b;
      @define-color yellow    #df8e1d;

      * {
        font-family: "Roboto", "Noto Color Emoji";
        font-size: 14px;
      }

      .notification {
        background-color: @surface0;
        border: 1px solid @surface1;
        border-radius: 12px;
        padding: 12px;
        margin: 6px;
      }

      .notification-content {
        color: @text;
      }

      .summary {
        font-weight: bold;
        color: @text;
      }

      .body {
        color: @subtext0;
      }

      .control-center {
        background-color: @base;
        border: 1px solid @surface1;
        border-radius: 16px;
        padding: 16px;
      }

      .widget-title {
        color: @text;
        font-weight: bold;
        font-size: 16px;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button {
        background-color: @surface0;
        color: @text;
        border-radius: 8px;
        padding: 8px;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background-color: @surface1;
      }

      .widget-volume {
        background-color: @surface0;
        border-radius: 8px;
        padding: 8px;
      }

      .widget-volume trough {
        background-color: @surface1;
        border-radius: 4px;
        min-height: 8px;
      }

      .widget-volume trough highlight {
        background-color: @blue;
        border-radius: 4px;
      }

      .widget-dnd {
        color: @text;
      }
    '';

    ".local/share/darkman/switch-theme" = {
      executable = true;
      text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        MODE="$1"

        WAYBAR_THEMES="$HOME/.config/waybar/themes"
        SWAYNC_THEMES="$HOME/.config/swaync/themes"
        ROFI_THEMES="$HOME/.config/rofi/themes"

        case "$MODE" in
          dark)
            WAYBAR_CSS="waybar-mocha.css"
            GTK_THEME="catppuccin-mocha-blue-standard+default"
            ICON_THEME="Qogir-Dark"
            CURSOR_THEME="catppuccin-mocha-blue-cursors"
            COLOR_SCHEME="prefer-dark"
            ROFI_THEME="rofi-mocha"
            ;;
          light)
            WAYBAR_CSS="waybar-latte.css"
            GTK_THEME="catppuccin-latte-blue-standard+default"
            ICON_THEME="Qogir-Light"
            CURSOR_THEME="catppuccin-latte-blue-cursors"
            COLOR_SCHEME="prefer-light"
            ROFI_THEME="rofi-latte"
            ;;
          *)
            echo "Unknown mode: $MODE"
            exit 1
            ;;
        esac

        # Update Waybar style
        if [ -f "$WAYBAR_THEMES/$WAYBAR_CSS" ]; then
          ln -sf "$WAYBAR_THEMES/$WAYBAR_CSS" "$HOME/.config/waybar/style.css"
          ${pkgs.procps}/bin/pkill -SIGUSR2 waybar || true
        fi

        # Update Swaync style
        if [ -f "$SWAYNC_THEMES/$MODE.css" ]; then
          ln -sf "$SWAYNC_THEMES/$MODE.css" "$HOME/.config/swaync/style.css"
          ${pkgs.swaynotificationcenter}/bin/swaync-client -rs || true
        fi

        # Update Rofi theme
        if [ -f "$ROFI_THEMES/$ROFI_THEME.rasi" ]; then
          ln -sf "$ROFI_THEMES/$ROFI_THEME.rasi" "$HOME/.config/rofi/theme.rasi"
        fi

        # Update GTK/Icon/Cursor themes
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"

        # Notify
        ${pkgs.libnotify}/bin/notify-send -i preferences-desktop-theme "Theme Switched" "Switched to $MODE mode." || true
      '';
    };
  };

  systemd.user.services.darkman = {
    Unit = {
      Description = "Darkman dark mode daemon";
      Documentation = "man:darkman(1)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "nl.whynothugo.darkman";
      ExecStart = "${pkgs.darkman}/bin/darkman run";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."xdg-desktop-portal/portals.conf".text = ''
    [preferred]
    default=gnome;gtk
    org.freedesktop.impl.portal.Settings=darkman
  '';

  home.activation.applyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $HOME/.config/waybar $HOME/.config/swaync $HOME/.config/rofi
    $DRY_RUN_CMD ${pkgs.darkman}/bin/darkman set $(${pkgs.darkman}/bin/darkman get 2>/dev/null || echo "dark") 2>/dev/null || true
  '';
}
