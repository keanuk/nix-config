{pkgs, ...}: {
  programs.halloy = {
    enable = true;
    package = pkgs.halloy;
    settings = {
      # theme = "{ light = \"ferra-light\", dark = \"ferra\" }";
      theme = {
        light = "ferra-light";
        dark = "ferra";
      };
      font = {
        family = "Iosevka Term";
        size = 18;
      };
      buffer.channel.topic = {
        enabled = true;
      };
      servers.liberachat = {
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
      servers.hackint = {
        server = "irc.hackint.org";
        port = 6697;
        nickname = "keanu";
        channels = [
          "#nixos"
        ];
      };
    };
  };
}
