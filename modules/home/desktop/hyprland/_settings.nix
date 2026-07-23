_: {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",preferred,auto,1"
    ];

    general = {
      gaps_in = 4;
      gaps_out = 8;
      border_size = 2;
      resize_on_border = true;
      "col.active_border" = "rgba(89b4faff) rgba(b4befeff) 45deg";
      "col.inactive_border" = "rgba(6c7080aa)";
    };

    decoration = {
      rounding = 12;
      active_opacity = 1.0;
      inactive_opacity = 0.9;
      fullscreen_opacity = 1.0;
      drop_shadow = true;
      shadow_range = 20;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1e1e2eff)";
      blur = {
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.02;
        passes = 3;
        popups = true;
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];
      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4.79, easeOutQuint, fade"
        "layersOut, 1, 1.49, linear, fade"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };

    input = {
      kb_layout = "us";
      follow_mouse = 1;
      touchpad = {
        natural_scroll = true;
        clickfinger_behavior = true;
        scroll_factor = 0.5;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_create_new = true;
      workspace_swipe_direction_lock = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_forever = true;
    };

    xwayland = {
      force_zero_scaling = true;
    };

    misc = {
      disable_splash_rendering = true;
      force_default_wallpaper = 0;
    };
  };
}
