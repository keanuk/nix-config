{pkgs, ...}: {
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    cachix
    docker
    docker-compose
    home-manager
    hwdata
    lsof
    pass
    pciutils
  ];
}
