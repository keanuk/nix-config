{pkgs, ...}: {
  imports = [
    ./binds.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./settings.nix

    ./rofi.nix
    ./waybar.nix
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
      variables = ["--all"];
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
}
