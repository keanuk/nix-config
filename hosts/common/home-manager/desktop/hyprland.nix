{ inputs, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./kitty.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    grim
    grimblast
    hyprpaper
    hyprpicker
    pamixer
    playerctl
    rofi-wayland
    swaynotificationcenter
    swww
    wayvnc
    wev
    wf-recorder
    kdePackages.polkit-kde-agent-1
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";
      "$altMod" = "ALT";
      "$shiftMod" = "SHIFT";

      exec-once = [
        # "waybar"
      ];

      animations = {
        enabled = true;
      };

      decoration = {
        rounding = 8;

        active_opacity = 1.0;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;

        drop_shadow = true;

        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          noise = 0.02;
          passes = 3;
          popups = true;
        };
      };

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 1;
        resize_on_border = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_create_new = true;
        workspace_swipe_direction_lock = false;
        workspace_swipe_fingers = 3;
        workspace_swipe_forever = true;
      };

      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          scroll_factor = 0.5;
        };
      };

      bind = [
        "$mod, RETURN, exec, alacritty"
        "$mod, F, exec, firefox-devedition"
        ", Print, exec, grimblast copy area"
        "$mod, SPACE, exec, rofi -show drun"
        "$altMod, SPACE, exec, rofi -show drun"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList
          (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );

      bindl = [
        # media control
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"

        # volume control: mute
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer --default-source -t"
      ];

      bindel = [
        # volume control
        ", XF86AudioRaiseVolume, exec, pamixer -i 10"
        ", XF86AudioLowerVolume, exec, pamixer -d 10"

        # brightness control
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      monitor = [
        # name, resolution, position, scale
        "eDP-1, 1920x1080, 0x0, 1"
      ];
    };
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
  };
}
