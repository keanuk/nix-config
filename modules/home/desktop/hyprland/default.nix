_: {
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      imports = [
        ./_binds.nix
        ./_settings.nix
        ./_rules.nix
      ];

      home.packages = with pkgs; [
        blueman
        libnotify
        nautilus
        wev
        wf-recorder
      ];

      home.pointerCursor = {
        enable = true;
        package = pkgs.catppuccin-cursors.mochaBlue;
        name = "catppuccin-mocha-blue-cursors";
        size = 24;
        x11.enable = true;
        gtk.enable = true;
      };

      # Home Manager's module defaults are what we want: hyprland-session.target
      # with BindsTo=graphical-session.target (which also starts noctalia's
      # systemd unit), and environment import into systemd and D-Bus.
      wayland.windowManager.hyprland.enable = true;
    };
}
