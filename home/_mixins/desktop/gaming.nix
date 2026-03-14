{ pkgs, ... }:
{
  home.packages = with pkgs.unstable; [
    airshipper
    bugdom
    cartridges
    dwarf-fortress
    flightgear
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
