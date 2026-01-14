{ pkgs, ... }:
{
  imports = [
    ../_mixins/user/keanu
  ];

  networking.hostName = "iso-console";

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    rsync
  ];

  # Basic ISO settings
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
