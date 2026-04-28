{
  flake.modules.homeManager.hyprland-tray =
    { pkgs, ... }:
    {
      imports = [
        ./_binds.nix
        ./_hypridle.nix
        ./_hyprpaper.nix
        ./_settings.nix

        ./_rofi.nix
        ./_waybar.nix
      ];

      home.packages = with pkgs; [
        brightnessctl
        grim
        grimblast
        hyprcursor
        hyprpaper
        hyprpicker
        hyprlock
        hypridle
        pamixer
        playerctl
        rofi-wayland
        swaynotificationcenter
        swww
        tailscale-systray
        wayvnc
        wev
        wf-recorder
        kdePackages.polkit-kde-agent-1
      ];

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
