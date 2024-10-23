{ inputs, pkgs, ... }:

{
  imports = [
    ./binds.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./settings.nix

    ../alacritty.nix
    ../kitty.nix
    ../rofi.nix
    ../waybar.nix
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
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
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
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
    ];
  };
}
