{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        marksman
        taplo
        yaml-language-server
      ];
    };
}
