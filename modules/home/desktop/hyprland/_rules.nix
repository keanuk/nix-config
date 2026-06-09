_: {
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "blur, waybar"
      "ignorezero, waybar"
      "blur, nwg-dock-hyprland"
      "ignorezero, nwg-dock-hyprland"
      "blur, swaync-control-center"
      "blur, swaync-notification-window"
      "ignorezero, swaync-control-center"
      "ignorezero, swaync-notification-window"
      "blur, rofi"
      "ignorezero, rofi"
    ];

    windowrulev2 = [
      "float, class:^(pavucontrol)$"
      "float, class:^(blueman-manager)$"
      "float, class:^(nm-connection-editor)$"
      "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
      "float, class:^(hyprpolkitagent)$"
      "float, title:^(Authentication Required)$"
      "size 800 600, class:^(pavucontrol)$"
      "size 800 600, title:^(Authentication Required)$"
    ];
  };
}
