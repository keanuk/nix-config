{ ... }:

{
  imports = [
    ./alacritty.nix  
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
