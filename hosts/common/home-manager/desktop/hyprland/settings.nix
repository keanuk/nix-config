{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprpaper"
      "hyprpicker"
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

    xwayland = {
      force_zero_scaling = true;
    };

    monitor = [
      # name, resolution, position, scale
      "eDP-1, 1920x1080, 0x0, 1"
    ];
  };
}
