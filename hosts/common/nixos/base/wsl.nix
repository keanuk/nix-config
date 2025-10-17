{...}: {
  imports = [
    ./packages.nix
    ./nix.nix

    ../services/comin.nix
    ../services/tailscale.nix

    ../programs/nh.nix
  ];

  wsl.enable = true;
}
