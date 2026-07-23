{ inputs, ... }:
{
  # The nixpkgs module already covers portals (gtk + gnome), polkit, gnome-keyring,
  # nautilus for the FileChooser portal, and the niri systemd session integration.
  # The package comes from the upstream flake so the session binary and the
  # home-manager config validation use the same niri build.
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = inputs.niri-wm.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };
    };
}
