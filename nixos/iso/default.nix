{ pkgs, ... }:
{
  imports = [
    ../_mixins/user/keanu
  ];

  networking.hostName = "iso-console";

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
