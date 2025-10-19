{...}: {
  imports = [
    ./packages.nix
    ./nix.nix

    ../services/comin/default.nix
    ../services/tailscale/default.nix

    ../programs/nh/default.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "keanu";
}
