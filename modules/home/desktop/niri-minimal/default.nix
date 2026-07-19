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
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia.systemd.enable = true;

      home = {
        packages = with pkgs; [
          blueman
          brightnessctl
          grim
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
