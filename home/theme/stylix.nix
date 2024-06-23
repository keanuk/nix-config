{ inputs, pkgs, ... }: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-dark.yaml";

  stylix.image = ;

}
