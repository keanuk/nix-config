{
  flake.modules.homeManager.niri-minimal =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [
        ./_niri.nix
      ];

      programs.noctalia.systemd.enable = false;

      home = {
        packages = with pkgs; [
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
          inputs.niri-wm.packages.${pkgs.stdenv.hostPlatform.system}.niri
        ];

        pointerCursor = {
          package = pkgs.catppuccin-cursors.mochaBlue;
          name = "catppuccin-mocha-blue-cursors";
          size = 24;
          x11.enable = true;
          gtk.enable = true;
        };
      };
    };
}
