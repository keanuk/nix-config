{
  dconf.settings = {
    "org/gnome/desktop/datetime" = { 
      automatic-timezone = true; 
    };
    "org/gnome/system/location" = { 
      enabled = true; 
    };
  };

  programs = {
    starship = {
      enableTransience = true;
    };
    zsh = {
      syntaxHighlighting.enable = true;
    };
  };
}
