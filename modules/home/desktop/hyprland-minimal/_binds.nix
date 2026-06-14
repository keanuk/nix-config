_: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$altMod" = "ALT";

    bind = [
      # Terminal
      "$mod, RETURN, exec, alacritty"

      # Launcher
      "$mod, SPACE, exec, noctalia-shell ipc call launcher toggle"
      "$altMod, SPACE, exec, noctalia-shell ipc call launcher toggle"

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

      # Lock
      "$mod, L, exec, hyprlock"

      # Screenshot
      ", Print, exec, grimblast copy area"
      "SHIFT, Print, exec, grimblast copy screen"
      "CTRL, Print, exec, grimblast copy active"

      # Color picker
      "$mod, C, exec, hyprpicker -a"

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
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioMute, exec, pamixer -t"
      ", XF86AudioMicMute, exec, pamixer --default-source -t"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];
  };
}
