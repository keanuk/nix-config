{lib, ...}: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts.sansSerif = lib.mkDefault ["Roboto"];
    defaultFonts.serif = lib.mkDefault ["Roboto Slab"];
    defaultFonts.monospace = lib.mkDefault ["RobotoMono Nerd Font"];
    defaultFonts.emoji = lib.mkDefault ["Noto Color Emoji"];
  };
}
