{ config, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      niriPkg = inputs.niri-wm.packages.${pkgs.stdenv.hostPlatform.system}.niri or pkgs.hello;
      screenshotScript =
        if pkgs.stdenv.hostPlatform.isLinux then
          pkgs.writeShellScript "niri-screenshot" ''
            set -euo pipefail
            ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
            ${pkgs.libnotify}/bin/notify-send -i camera-photo "Screenshot" "Screenshot copied to clipboard."
          ''
        else
          "";
      screenshotFullScript =
        if pkgs.stdenv.hostPlatform.isLinux then
          pkgs.writeShellScript "niri-screenshot-full" ''
            set -euo pipefail
            ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy
            ${pkgs.libnotify}/bin/notify-send -i camera-photo "Screenshot" "Screenshot copied to clipboard."
          ''
        else
          "";
      baseSettings = import ./_base-settings.nix;
    in
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        package = niriPkg;
        settings = lib.recursiveUpdate baseSettings {
          spawn-at-startup = [
            "systemctl --user start graphical-session.target"
            "waybar"
            "swaync"
          ];

          binds = {
            "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg panel-toggle launcher";
            "Mod+Tab".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg window-switcher";
            "Mod+L".spawn-sh = "${lib.getExe self'.packages.myNoctalia} msg session lock";
            "Mod+S".spawn = "${screenshotScript}";
            "Mod+Shift+S".spawn = "${screenshotFullScript}";
          };
        };
      };
    };

  flake.modules.homeManager.niri =
    {
      pkgs,
      ...
    }:
    let
      self' = config.perSystem pkgs.stdenv.hostPlatform.system;
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
        self'.packages.myNiri
      ];

      home.pointerCursor = {
        enable = true;
        package = pkgs.catppuccin-cursors.mochaBlue;
        name = "catppuccin-mocha-blue-cursors";
        size = 24;
        x11.enable = true;
        gtk.enable = true;
      };

      xdg.configFile."niri/config.kdl".text = ''
        include "${self'.packages.myNiri}/niri-config.kdl"
        include "noctalia.kdl"
      '';
    };
}
