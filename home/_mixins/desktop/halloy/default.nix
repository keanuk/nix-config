{
  pkgs,
  lib,
  ...
}:
{
  programs.halloy = {
    enable = true;
    package = pkgs.halloy;
    settings = {
      theme = lib.mkDefault {
        light = lib.mkDefault "catppuccin-latte";
        dark = lib.mkDefault "catppuccin-mocha";
      };
      font = {
        family = "Iosevka Term";
        size = 18;
      };
      buffer.channel.topic = {
        enabled = true;
      };
      servers = {
        liberachat = {
          server = "irc.libera.chat";
          port = 6697;
          nickname = "keanu";
          channels = [
            "#archlinux"
            "#gnome"
            "#halloy"
            "#halloy-dev"
            "#libera"
            "#linux"
            "#nixos"
            "#nixos-chat"
            "#nixos-dev"
            "#nix-darwin"
            "#plug"
          ];
        };
        hackint = {
          server = "irc.hackint.org";
          port = 6697;
          nickname = "keanu";
          channels = [
            "#nixos"
          ];
        };
        oftc = {
          server = "irc.oftc.net";
          port = 6697;
          nickname = "keanu";
          channels = [
            "#bcache"
          ];
        };
      };
    };
  };
}
