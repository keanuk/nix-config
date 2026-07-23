_: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$altMod" = "ALT";

    bind = [
      # Terminal
      "$mod, RETURN, exec, alacritty"

      # Noctalia
      "$mod, SPACE, exec, noctalia msg panel-toggle launcher"
      "$altMod, SPACE, exec, noctalia msg panel-toggle launcher"
      "$mod, L, exec, noctalia msg session lock"
      ", Print, exec, noctalia msg screenshot-region"
      "SHIFT, Print, exec, noctalia msg screenshot-fullscreen"

      # Window management
      "$mod, Q, killactive,"
      "$mod SHIFT, Q, forcekillactive,"
      "$mod, F, fullscreen, 0"
      "$mod SHIFT, F, fullscreen, 1"
      "$mod, X, togglefloating,"
      "$mod, G, togglegroup,"
      "$mod, P, pseudo,"
      "$mod, S, togglesplit,"

      # Focus
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # Move
      "$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"

      # Resize
      "$mod CTRL, left, resizeactive, -20 0"
      "$mod CTRL, right, resizeactive, 20 0"
      "$mod CTRL, up, resizeactive, 0 -20"
      "$mod CTRL, down, resizeactive, 0 20"

      # Workspaces
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Special workspace
      "$mod SHIFT, grave, movetoworkspace, special"
      "$mod, grave, togglespecialworkspace,"
    ]
    ++ (builtins.concatLists (
      builtins.genList (
        x:
        let
          ws = builtins.toString (x + 1);
        in
        [
          "$mod, ${ws}, workspace, ${ws}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
        ]
      ) 10
    ));

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bindl = [
      ", XF86AudioPlay, exec, noctalia msg media toggle"
      ", XF86AudioPrev, exec, noctalia msg media previous"
      ", XF86AudioNext, exec, noctalia msg media next"
      ", XF86AudioMute, exec, noctalia msg volume-mute"
      ", XF86AudioMicMute, exec, noctalia msg mic-mute"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, noctalia msg volume-up"
      ", XF86AudioLowerVolume, exec, noctalia msg volume-down"
      ", XF86MonBrightnessUp, exec, noctalia msg brightness-up"
      ", XF86MonBrightnessDown, exec, noctalia msg brightness-down"
    ];
  };
}
