{
  flake.modules.homeManager.hyprland =
    {
      pkgs,
      ...
    }:
    let
      catppuccin-gtk-mocha = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "blue" ];
      };
      catppuccin-gtk-latte = pkgs.catppuccin-gtk.override {
        variant = "latte";
        accents = [ "blue" ];
      };
    in
    {
      imports = [
        ./_binds.nix
        ./_hypridle.nix
        ./_hyprlock.nix
        ./_hyprpaper.nix
        ./_settings.nix
        ./_rules.nix
        ./_waybar.nix
        ./_dock.nix
        ./_theme.nix
        ./_rofi.nix
        ./_notifications.nix
      ];

      home.packages = with pkgs; [
        blueman
        brightnessctl
        catppuccin-gtk-mocha
        catppuccin-gtk-latte
        darkman
        grim
        grimblast
        hyprcursor
        hyprpaper
        hyprpicker
        hyprlock
        hypridle
        hyprpolkitagent
        libnotify
        nwg-dock-hyprland
        pamixer
        playerctl
        rofi-wayland
        swaynotificationcenter
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
