{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/persist/home/keanu" = {
    directories = [
      "Bilder"
      "Dokumente"
      "Downloads"
      "Musik"
      "Projects"
      "Schreibtisch"
      "Videos"
      "Vorlagen"
      "Öffentlich"

      "go"

      ".gnupg"
      ".ssh"
      ".nixops"

      ".local/share/keyrings"
      ".local/share/direnv"

      ".config/cosmic"
      ".config/gh"
      ".config/gtk-3.0"
      ".config/gtk-4.0"     
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
