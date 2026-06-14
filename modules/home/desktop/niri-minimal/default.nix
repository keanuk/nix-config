{
  flake.modules.homeManager.niri-minimal =
    { pkgs, ... }:
    {
      imports = [
        ./_niri.nix
      ];

      home.packages = with pkgs; [
        blueman
        brightnessctl
        grim
        hyprlock
        libnotify
        nautilus
        pamixer
        playerctl
        slurp
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
