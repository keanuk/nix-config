{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    android-studio
    androidStudioPackages.beta
    androidStudioPackages.dev
    jetbrains.idea-community
    jetbrains.pycharm-community
  ];
}
