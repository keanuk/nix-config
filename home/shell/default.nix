{ pkgs, ... }:

{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./broot.nix
    ./carapace.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./helix.nix
    ./micro.nix
    ./nushell.nix
    ./ripgrep.nix
    ./starship.nix
    ./thefuck.nix
    ./yazi.nix
    ./yt-dlp.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.libxkbcommon.dev}/lib/pkgconfig";
  };
}
