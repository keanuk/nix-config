{
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      services.displayManager.gdm.enable = true;

      programs.niri = {
        enable = true;
        useNautilus = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        config.niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Settings" = "darkman";
        };
      };
    };
}
