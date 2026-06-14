{
  flake.modules.homeManager.niri =
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
        ./_niri.nix
        ./_waybar.nix
        ./_theme.nix
        ./_notifications.nix
        ./_rofi.nix
        ./_polkit.nix
      ];

      home.packages = with pkgs; [
        blueman
        brightnessctl
        catppuccin-gtk-mocha
        catppuccin-gtk-latte
        darkman
        grim
        hyprlock
        libnotify
        nautilus
        pamixer
        playerctl
        rofi-wayland
        slurp
        swaynotificationcenter
        wev
        wf-recorder
      ];

      home.pointerCursor = {
        package = pkgs.catppuccin-cursors.mochaBlue;
        name = "catppuccin-mocha-blue-cursors";
        size = 24;
        x11.enable = true;
        gtk.enable = true;
      };
    };
}
