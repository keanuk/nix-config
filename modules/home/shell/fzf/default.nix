{
  flake.modules.homeManager.shell =
    { pkgs, lib, options ? { }, ... }:
    {
      programs.fzf = {
        enable = true;
        package = pkgs.fzf;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      } // lib.optionalAttrs (lib.hasAttrByPath [ "programs" "fzf" "historyWidget" ] options) {
        historyWidget.command = "";
      };
    };
}
