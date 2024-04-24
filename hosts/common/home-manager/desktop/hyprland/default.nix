{ inputs, pkgs, ... }:

{
  imports = [
    ./binds.nix
    # ./hypridle.nix
    # ./hyprpaper.nix
    ./settings.nix

    ../alacritty.nix
    ../kitty.nix
    ../waybar.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    grim
    grimblast
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
    systemd = {
      enable = true;
      variables = [ "--all" ];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    xwayland.enable = true;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
  };
}
