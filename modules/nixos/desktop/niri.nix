_: {
  # The nixpkgs module already covers portals (gtk + gnome), polkit, gnome-keyring,
  # nautilus for the FileChooser portal, and the niri systemd session integration.
  # The package comes from nixpkgs so it shares the same glibc and Mesa drivers as
  # the rest of the system.
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
      environment.systemPackages = with pkgs; [
        easyeffects
        nwg-displays
      ];
    };
}
