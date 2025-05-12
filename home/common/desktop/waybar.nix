{
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    style = "../theme/waybar.css";
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };

    settings = [
      {
        exclusive = true;
        position = "top";
        layer = "top";
        height = 32;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "temparature#cpu"
          "cpu"
          "idle_inhibitor"
          "custom/music"
          "pulseaudio#source"
          "wireplumber"
          "backlight"
          "bluetooth"
          "network"
          "battery"
          "group/group-power"
        ];

        "tray" = {
          "icon-size" = 21;
          "spacing" = 10;
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
          };
        };

        "network" = {
          format-wifi = "{icon}";
          format-ethernet = "{ifname} ";
          format-disconnected = "";
          format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
          tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
          max-length = 15;
          on-click = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.networkmanager}/bin/nmtui";
        };

        "bluetooth" = {
          format-on = "";
          format-connected = "";
          format-off = "";
          format-disabled = "";
          tooltip-format = "{device_alias}";
          on-click-right = "${lib.getExe' pkgs.blueberry "blueberry"}";
          # on-click = "${lib.getExe bluetoothToggle}";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "battery" = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "";
          tooltip-format = "{time} ({capacity}%)";
          format-alt = "{time} {icon}";
          format-full = "";
          format-icons = ["" "" "" "" ""];
        };

        "group/group-power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            "custom/lock"
            "custom/reboot"
            "custom/quit"
          ];
        };

        "custom/quit" = {
          format = "󰗼";
          on-click = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
          tooltip = false;
        };

        "custom/lock" = {
          format = "󰍁";
          on-click = "${lib.getExe pkgs.hyprlock}";
          tooltip = false;
        };

        "custom/reboot" = {
          format = "󰜉";
          on-click = "${pkgs.systemd}/bin/systemctl reboot";
          tooltip = false;
        };

        "custom/power" = {
          format = "";
          on-click = "${pkgs.systemd}/bin/systemctl poweroff";
          tooltip = false;
        };

        "clock" = {
          format = "{:%d %b %H:%M}";
          "format-alt" = "{:%d/%m/%Y}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "backlight" = {
          "device" = "intel_backlight";
          "format" = "{icon}";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
        };

        "wireplumber" = {
          format = "{icon}";
          format-muted = "";
          on-click = "${lib.getExe pkgs.pavucontrol}";
          format-icons = ["" "" ""];
          tooltip-format = "{volume}% / {node_name}";
        };

        "pulseaudio#source" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
          on-click = "${lib.getExe pkgs.pavucontrol}";
          tooltip-format = "{source_volume}% / {desc}";
        };

        "custom/music" = {
          "format" = "  {}";
          "escape" = true;
          "interval" = 5;
          "tooltip" = false;
          "exec" = "playerctl metadata --format='{{ title }}'";
          "on-click" = "playerctl play-pause";
          "max-length" = 50;
        };

        "cpu" = {
          interval = 1;
          format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}{icon16}{icon17}{icon18}{icon19}{icon20}{icon21}{icon22}{icon23}";
          format-icons = ["" "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          states = {
            warning = 20;
            critical = 50;
          };
        };

        "temperature#cpu" = {
          interval = 1;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 60;
          format = "{icon} {temperatureC}°";
          format-icons = [""];
        };
      }
    ];
  };
}
