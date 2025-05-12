{...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    enableTransience = true;
    settings = import ../theme/starship.nix;
  };
}
