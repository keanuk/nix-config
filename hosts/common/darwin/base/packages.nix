{ pkgs, ... }:

{
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  environment.systemPackages = with pkgs; [
    cachix
    docker
    docker-compose
    fish
    git
    helix
    home-manager
    hwdata
    lsof
    nushell
    pass
    pciutils
    podman
    starship
    tailscale
    wireguard-tools
  ];

  users.users.keanu.packages = with pkgs; [
    age
    alacritty
    android-tools
    audacity
    cpufetch
    darktable
    discord
    element-desktop
    fastfetch
    ffmpeg
    fortune
    gimp
    git-crypt
    inkscape
    just
    kind
    kitty
    kubectl
    libnatpmp
    netbird-dashboard
    netbird-ui
    nix-index
    nmap
    onefetch
    protonmail-bridge
    protonmail-desktop
    ripgrep
    signal-desktop
    sops
    ssh-to-age
    telegram-desktop
    tlrc
    transmission_4
    tree
    typst
    wget
    yt-dlp
    zlib-ng
  ];

  fonts = {
    packages = with pkgs; [
      font-awesome
      inter
      nerdfonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      powerline-fonts
      source-code-pro
    ];
  };
}
