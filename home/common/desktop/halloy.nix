{ pkgs, ... }: {
  programs.halloy = {
    enable = true;
    package = pkgs.halloy;
    settings = {
      "buffer.channel.topic" = {
        enabled = true;
      };
      "servers.liberachat" = {
        channels = [
          "#halloy"
        ];
        nickname = "keanu";
        server = "irc.libera.chat";
      };
    };
  };
}
