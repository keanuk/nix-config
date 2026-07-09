{
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs.unstable; [
        airshipper
        bugdom
        cartridges
        celeste64
        dwarf-fortress
        heroic
        nanosaur
        nanosaur2
        openra
        otto-matic
        redeclipse
        sauerbraten
        shattered-pixel-dungeon
        supertux
        supertuxkart
        wesnoth
        xonotic
        zeroad
      ];
    };
}
