{ ... }:

{
  imports = [
    ./alacritty.nix
    ./chromium.nix
    ./firefox.nix
    ./thunderbird.nix
    ./vscode.nix
  ];
  
  programs = {
    starship = {
      enableTransience = true;
    };
    zsh = {
      syntaxHighlighting.enable = true;
    };
  };
}
