{ ... }:
{
  imports = [
    ./packages.nix
    ./nix.nix

    ../services/comin
    ../services/tailscale

    ../programs/nh
  ];

  wsl.enable = true;
  wsl.defaultUser = "keanu";
}
