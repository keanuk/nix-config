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
    git
    helix
    home-manager
    hwdata
    lsof
    nushell
    pass
    pciutils
    starship
  ];
}
