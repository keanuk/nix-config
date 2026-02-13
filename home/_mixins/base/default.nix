{ ... }:
{
  imports = [
    ../shell

    ../fixes
  ];

  programs.home-manager = {
    enable = true;
  };

  news.display = "notify";
}
