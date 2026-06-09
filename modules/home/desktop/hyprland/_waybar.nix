{
  pkgs,
  lib,
  ...
}:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    style = null; # managed by darkman theme script
    systemd = {
      enable = false;
    };

    settings = [
      {
        exclusive = true;
        position = "top";
        layer = "top";
        height = 36;
        margin = "6 6 0 6";

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "tray"
          "idle_inhibitor"
          "custom/notification"
          "pulseaudio"
          "network"
          "bluetooth"
          "battery"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            default = "";
          };
        };

        "clock" = {
          format = "{:%a %b %d  %H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "tray" = {
          icon-size = 16;
          spacing = 8;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
          tooltip = true;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "󰅸";
            none = "󰂚";
            dnd-notification = "󰅸";
            dnd-none = "󱏨";
            inhibited-notification = "󰅸";
            inhibited-none = "󰂚";
            dnd-inhibited-notification = "󰅸";
            dnd-inhibited-none = "󱏨";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 muted";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            headphone = "󰋋";
            headset = "󰋋";
            phone = "󰏲";
            portable = "󰏲";
            car = "󰄋";
          };
          on-click = "${lib.getExe pkgs.pavucontrol}";
          on-click-right = "pamixer -t";
        };

        "network" = {
          format-wifi = "󰤨";
          format-ethernet = "󰈀";
          format-disconnected = "󰌙";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) {ipaddr}";
          tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.networkmanager}/bin/nmtui";
        };

        "bluetooth" = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          format-off = "󰂲";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        "battery" = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        "custom/power" = {
          format = "󰐥";
          on-click = "echo -e \"Lock\\nLogout\\nReboot\\nShutdown\" | rofi -dmenu -p \"Power\" | xargs -I {} sh -c 'case {} in Lock) hyprlock ;; Logout) hyprctl dispatch exit ;; Reboot) systemctl reboot ;; Shutdown) systemctl poweroff ;; esac'";
          tooltip = false;
        };
      }
    ];
  };

  # Theme CSS files
  home.file.".config/waybar/themes/waybar-mocha.css".source = ./waybar-mocha.css;
  home.file.".config/waybar/themes/waybar-latte.css".source = ./waybar-latte.css;
}
