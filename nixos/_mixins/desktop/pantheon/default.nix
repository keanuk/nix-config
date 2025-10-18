{...}: {
  services = {
    pantheon.apps.enable = true;
    xserver = {
      displayManager.lightdm.enable = true;
      desktopManager.pantheon.enable = true;
    };
  };
}
