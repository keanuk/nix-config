{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    android-studio
    androidStudioPackages.beta
    androidStudioPackages.dev
    gnome-builder
    jetbrains.idea-community
    jetbrains.pycharm-community
  ];
}
