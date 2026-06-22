{
  flake.modules.nixos.pantheon =
    { pkgs, ... }:
    {
      programs.seahorse.enable = true;

      services = {
        pantheon.apps.enable = true;
        xserver.displayManager.lightdm.enable = true;
        desktopManager.pantheon.enable = true;
      };

      xdg.portal.extraPortals = [ pkgs.pantheon.xdg-desktop-portal-pantheon ];
    };
}
