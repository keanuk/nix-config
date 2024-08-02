{ pkgs, inputs, ... }:

{
  imports = [ "${inputs.nixpkgs}/nixos/modules/services/misc/flaresolverr.nix" ];
  
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    package = pkgs.unstable.flaresolverr;
  };
}
