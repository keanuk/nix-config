{ pkgs, ... }:
{
  home.packages = with pkgs.unstable; [
    airshipper
    bugdom
    cartridges
    dwarf-fortress
    # TODO: switch back to unstable when build is fixed
    pkgs.stable.flightgear
    heroic
    nanosaur
    nanosaur2
    otto-matic
    shattered-pixel-dungeon
    supertux
    supertuxkart
    wesnoth
    xonotic
    zeroad
  ];
}
