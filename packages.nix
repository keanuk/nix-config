{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpid
    font-awesome
    libglvnd
	libxkbcommon
    nerdfonts
    pciutils
    powerline-fonts
    psmisc
    SDL2
    snapper
    snapper-gui
    source-code-pro
    usbutils
  ];

  users.users.keanu.packages = with pkgs; [
    android-tools
    btop
    cargo
    flutter
    gcc
    gh
    go
    htop
    jdk
    kotlin
    neofetch
    netbird-ui
    nixfmt
    nodejs
    nodePackages."@angular/cli"
    nodePackages.typescript
    protonvpn-cli
    protonvpn-gui
    python3Full
    rustc
    steam-run
    tealdeer
    tree
    vim
    vscode-fhs
    wget
    wl-clipboard
    xclip
  ];

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;
  services.atuin.enable = true;

  # Nix Packages
  nixpkgs.config = {
    allowUnfree = true;
    # permittedInsecurePackages = [];
  };

  environment.sessionVariables = {};
}
