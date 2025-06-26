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
    home-manager
    hwdata
    lsof
    pass
    pciutils
  ];
}
