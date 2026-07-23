_: {
  wayland.windowManager.hyprland.settings = {
    # Noctalia rules follow the upstream recommendations:
    # https://docs.noctalia.dev/v5/compositor-settings/hyprland/
    windowrulev2 = [
      "float, class:^(dev.noctalia.Noctalia)$"
      "size 1080 920, class:^(dev.noctalia.Noctalia)$"
      "float, class:^(pavucontrol)$"
      "float, class:^(blueman-manager)$"
      "float, class:^(nm-connection-editor)$"
      "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
      "float, class:^(hyprpolkitagent)$"
      "float, title:^(Authentication Required)$"
      "size 800 600, class:^(pavucontrol)$"
      "size 800 600, title:^(Authentication Required)$"
    ];

    layerrule = [
      "noanim, namespace:^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"
      "blur, namespace:^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"
      "blurpopups, namespace:^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"
      "ignorealpha 0.5, namespace:^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"
    ];
  };
}
