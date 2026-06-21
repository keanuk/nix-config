{
  flake.modules.nixos.plasma =
    { pkgs, ... }:
    {
      services.displayManager = {
        sddm.enable = true;
        defaultSession = "plasma";
        sddm.wayland.enable = true;
      };

      services.desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = true;
        notoPackage = pkgs.noto-fonts;
      };

      environment.systemPackages = with pkgs; [
        kdePackages.discover
        kdePackages.kmail
        kdePackages.konversation
        kdePackages.neochat
      ];

      qt.enable = true;
    };
}
