{...}: {
  imports = [
    ../_mixins/base/default.nix
    ../_mixins/base/home-manager.nix
    ../_mixins/base/wsl.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "25.11";
  };
}
