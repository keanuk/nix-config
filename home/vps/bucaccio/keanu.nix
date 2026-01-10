{...}: {
  imports = [
    ../../_mixins/base/vps.nix
    ../../_mixins/base/home-manager.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.11";
  };
}
