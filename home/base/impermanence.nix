{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/persist/home/keanu" = {
    directories = [
      "Downloads"
      "Documents"
      "Projects"
      "Pictures"
      "Music"
      "Videos"
      "go"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"

      ".config/gh"
      ".config/cosmic"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [
      ".screenrc"
    ];
    allowOther = true;
  };
}
