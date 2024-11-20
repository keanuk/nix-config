{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    android-studio
    androidStudioPackages.beta
    androidStudioPackages.dev
    gnome-builder
    zed-editor

    jetbrains.idea-community
    jetbrains.pycharm-community
  ];
}
