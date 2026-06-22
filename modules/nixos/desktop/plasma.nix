{
  flake.modules.nixos.plasma =
    { pkgs, ... }:
    {
      nixpkgs.config.permittedInsecurePackages = [
        "olm-3.2.16"
      ];

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
