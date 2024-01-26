{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      font-awesome
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      powerline-fonts
      source-code-pro
  ];

  users.users.keanu.packages = with pkgs; [
  ];

  environment.sessionVariables = {};
}
