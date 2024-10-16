{ inputs, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = inputs.waybar.packages."${pkgs.system}".waybar;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };

    settings = [{
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
        format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
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
        format-icons = [ "" "" "" "" "" ];
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
        format-icons = [ "" "" "" ];
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
        format-icons = [ "" "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
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
        format-icons = [ "" ];
      };
    }];

    style = ''

      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;
    
     * {
        font-family: FantasqueSansMono Nerd Font;
        font-size: 17px;
        min-height: 0;
        border: 0px;
        border-radius: 0px;
        padding: 0px;
        margin: 0px;
      }

      #waybar {
        background: transparent;
        color: @text;
        margin: 5px 5px;
        border-radius: 1rem;
      }

      #workspaces {
        border-radius: 1rem;
        background-color: @surface0;
        margin-left: 1rem;
        margin: 5px;
      }

      #workspaces button {
        color: @lavender;
        border-radius: 1rem;
        padding: 0.5rem;
      }

      #workspaces button.active {
        color: @sky;
        border-radius: 1rem;
      }

      #workspaces button:hover {
        color: @sapphire;
        border-radius: 1rem;
      }

      #tray,
      #backlight,
      #battery,
      #clock,
      #custom-music,
      #pulseaudio,
      #wireplumber,
      #custom-lock,
      #custom-power,
      #custom-reboot,
      #custom-quit,
      #network,
      #idle_inhibitor,
      #bluetooth {
        background-color: @surface0;
        padding: 1rem 1rem;
        margin: 5px 0px;
      }

      #clock {
        color: @blue;
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        margin-left: 1rem;
        margin-right: 1rem;
      }

      #battery {
        color: @green;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
      }

      #backlight {
        color: @yellow;
      }

      #backlight, #battery {
        border-radius: 0;
      }

      #pulseaudio {
        color: @maroon;
      }

      #idle_inhibitor {
        color: @maroon;
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }

      #custom-music {
        color: @mauve;
        border-radius: 1rem;
      }

      #custom-lock {
        border-radius: 1rem 0px 0px 1rem;
        color: @lavender;
      }

      #custom-reboot {
        color: @lavender;
      }

      #custom-quit {
        color: @lavender;
      }

      #custom-power {
        margin-right: 1rem;
        border-radius: 0px 1rem 1rem 0px;
        color: @red;
      }

      #tray {
        margin-right: 1rem;
        border-radius: 1rem;
      }

    '';
  };
}
