{ config, ... }:
let
  mkFonts =
    {
      includeNotoNerd ? true,
    }:
    { pkgs, ... }:
    {
      fonts.packages =
        (with pkgs; [
          cantarell-fonts
          fira-code
          fira-mono
          font-awesome
          hack-font
          inter
          jetbrains-mono
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          powerline-fonts
          roboto
          roboto-flex
          roboto-mono
          roboto-serif
          roboto-slab
          source-code-pro

          nerd-fonts.fira-code
          nerd-fonts.fira-mono
          nerd-fonts.hack
          nerd-fonts.jetbrains-mono
          nerd-fonts.roboto-mono
        ])
        ++ pkgs.lib.optional includeNotoNerd pkgs.nerd-fonts.noto;
    };
in
{
  flake.modules = {
    nixos.desktop = mkFonts { includeNotoNerd = true; };

    darwin = {
      desktop-fonts = mkFonts { includeNotoNerd = false; };
      base = config.flake.modules.darwin.desktop-fonts;
    };
  };
}
