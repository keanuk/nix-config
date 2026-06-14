{
  flake.modules.homeManager.hyprland-minimal =
    { pkgs, ... }:
    {
      imports = [
        ./_binds.nix
        ./_hyprlock.nix
        ./_settings.nix
        ./_rules.nix
      ];

      home.packages = with pkgs; [
        blueman
        brightnessctl
        grim
        grimblast
        hyprcursor
        hyprlock
        libnotify
        nautilus
        pamixer
        playerctl
        wev
        wf-recorder
        xdg-desktop-portal-hyprland
      ];

      home.pointerCursor = {
        package = pkgs.catppuccin-cursors.mochaBlue;
        name = "catppuccin-mocha-blue-cursors";
        size = 24;
        x11.enable = true;
        gtk.enable = true;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;
        systemd = {
          enable = true;
          variables = [ "--all" ];
          extraCommands = [
            "systemctl --user stop graphical-session.target"
            "systemctl --user start hyprland-session.target"
          ];
        };
        plugins = [
          pkgs.hyprlandPlugins.hyprbars
          pkgs.hyprlandPlugins.hyprexpo
          pkgs.hyprlandPlugins.hyprtrails
        ];
      };
    };
}
