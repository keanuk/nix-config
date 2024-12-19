{ pkgs, ... }: {
  services.protonmail-bridge = {
    enable = true;
    package = pkgs.protonmail-bridge;
    path = with pkgs; [
      pass
      gnome-keyring
    ];
  };
}
