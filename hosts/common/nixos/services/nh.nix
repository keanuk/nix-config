{ ... }:

{
  programs.nh = {
    enable = true;
    flake = /home/keanu/.config/nix-config;
    clean.enable = false;
  };
}
