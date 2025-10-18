{...}: {
  imports = [
    ../_mixins/base/default.nix

    ../_mixins/darwin/default.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/Users/keanu";
    stateVersion = "24.05";
  };
}
