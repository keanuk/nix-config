{lib, ...}: {
  imports = [
    ../common/base/default.nix
    ../common/base/home-manager.nix

    ../common/desktop/default.nix
    ../common/desktop/gnome.nix

    ../common/shell/packages.nix
  ];

  home = {
    username = "keanu";
    homeDirectory = "/home/keanu";
    stateVersion = "23.11";
  };

  programs.zed-editor.userSettings = {
    ui_font_size = lib.mkForce 18;
    buffer_font_size = lib.mkForce 18;
  };
}
