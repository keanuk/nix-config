{lib, ...}: {
  imports = [
    ./packages.nix

    ../shell/nh.nix

    ../dev/default.nix
  ];

  programs.atuin.daemon.enable = lib.mkForce false;
}
