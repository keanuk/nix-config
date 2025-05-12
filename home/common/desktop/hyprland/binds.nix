{...}: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$altMod" = "ALT";
    "$shiftMod" = "SHIFT";

    bind =
      [
        "$mod, RETURN, exec, alacritty"
        "$mod, F, exec, fullscreen"
        ", Print, exec, grimblast copy area"
        "$mod, SPACE, exec, rofi -show drun"
        "$altMod, SPACE, exec, rofi -show drun"
        "$mod, TAB, exec, cyclenext"
        "$altMod, TAB, exec, cyclenext"
        "$mod, X, exec, togglefloating"
        "$altMod, X, exec, togglefloating"
        "$mod, Q, exec, killactive"
        "$mod, W, exec, closewindow"
        "$mod, L, exec, hyprlock"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList
          (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
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
  };
}
