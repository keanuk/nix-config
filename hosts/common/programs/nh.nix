{pkgs, ...}: {
  programs.nh = {
    enable = true;
    package = pkgs.nh;
    flake = "/home/keanu/.config/nix-config";
    clean.enable = false;
  };

  # needed for Determinate nix since flakes and nix command are enabled by default
  environment.variables.NH_NO_CHECKS = 1;
}
