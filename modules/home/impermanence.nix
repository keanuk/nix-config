{ inputs, ... }:
{
  flake.modules.homeManager.impermanence =
    { config, ... }:
    {
      imports = [
        inputs.impermanence.nixosModules.home-manager.impermanence
      ];

      home.persistence."/persist/home/${config.home.username}" = {
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
          ".nixops"
          ".ssh"
          ".steam"

          ".local/share/direnv"
          ".local/share/keyrings"
          ".local/share/protonmail"
          ".local/state/cosmic"
          ".local/state/cosmic-comp"
          ".local/state/pop-launcher"

          ".config/cosmic"
          ".config/gh"
          ".config/gtk-3.0"
          ".config/gtk-4.0"
          ".config/nix-config"
          ".config/protonmail"
          ".config/sops"
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
    };
}
