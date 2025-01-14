{ pkgs, ... }:

{
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    # TODO switch back to pkgs.flaresolverr when the package is fixed
    # https://github.com/NixOS/nixpkgs/issues/332776
    package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw;
  };
}
