{ pkgs, ... }:
{
  programs.distrobox = {
    enable = true;
    package = pkgs.distrobox;
    containers = {
      arch = {
        entry = true;
        image = "archlinux:latest";
        additional_packages = "git";
      };
      debian = {
        entry = true;
        image = "debian:latest";
        additional_packages = "git";
      };
      fedora = {
        entry = true;
        image = "fedora:latest";
        additional_packages = "git";
      };
    };
  };
}
