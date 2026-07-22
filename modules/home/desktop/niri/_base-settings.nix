{
  input = {
    keyboard.xkb.layout = "us";
    touchpad = {
      tap = _: { };
      natural-scroll = _: { };
    };
    mouse = {
      natural-scroll = _: { };
    };
  };

  outputs = {
    "*" = {
      scale = 1.0;
    };
  };

  layout = {
    gaps = 8;
    border = {
      width = 2;
      active-color = "#89b4fa";
      inactive-color = "#45475a";
    };
    focus-ring = {
      width = 4;
      active-color = "#89b4fa";
      inactive-color = "#45475a";
    };
    default-column-width.proportion = 0.5;
    center-focused-column = "on-overflow";
  };

  environment = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_OZONE_WL = "1";
  };

  binds = {
    "Mod+Return".spawn = "alacritty";
    "Mod+Q".close-window = _: { };
    "Mod+Shift+Q".quit = _: { };
    "Mod+F".fullscreen-window = _: { };
    "Mod+Shift+F".maximize-column = _: { };
    "Mod+C".center-column = _: { };
    "Mod+Shift+Space".toggle-window-floating = _: { };
    "Mod+Left".focus-column-left = _: { };
    "Mod+Right".focus-column-right = _: { };
    "Mod+Up".focus-window-up = _: { };
    "Mod+Down".focus-window-down = _: { };
    "Mod+Shift+Left".move-column-left = _: { };
    "Mod+Shift+Right".move-column-right = _: { };
    "Mod+Shift+Up".move-window-up = _: { };
    "Mod+Shift+Down".move-window-down = _: { };
    "Mod+Comma".focus-workspace-up = _: { };
    "Mod+Period".focus-workspace-down = _: { };
    "Mod+Shift+Comma".move-column-to-workspace-up = _: { };
    "Mod+Shift+Period".move-column-to-workspace-down = _: { };
    "Mod+1".focus-workspace = 1;
    "Mod+2".focus-workspace = 2;
    "Mod+3".focus-workspace = 3;
    "Mod+4".focus-workspace = 4;
    "Mod+5".focus-workspace = 5;
    "Mod+6".focus-workspace = 6;
    "Mod+7".focus-workspace = 7;
    "Mod+8".focus-workspace = 8;
    "Mod+9".focus-workspace = 9;
    "Mod+0".focus-workspace = 10;
    "Mod+Shift+1".move-column-to-workspace = 1;
    "Mod+Shift+2".move-column-to-workspace = 2;
    "Mod+Shift+3".move-column-to-workspace = 3;
    "Mod+Shift+4".move-column-to-workspace = 4;
    "Mod+Shift+5".move-column-to-workspace = 5;
    "Mod+Shift+6".move-column-to-workspace = 6;
    "Mod+Shift+7".move-column-to-workspace = 7;
    "Mod+Shift+8".move-column-to-workspace = 8;
    "Mod+Shift+9".move-column-to-workspace = 9;
    "Mod+Shift+0".move-column-to-workspace = 10;
  };
}
