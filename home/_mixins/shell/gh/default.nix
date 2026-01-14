{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    package = pkgs.gh;
    gitCredentialHelper.enable = true;
    extensions = with pkgs; [
      gh-copilot
      gh-dash
      gh-eco
      gh-f
      gh-i
      gh-notify
      gh-s
    ];
  };
}
