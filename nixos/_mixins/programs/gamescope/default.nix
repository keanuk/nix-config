{pkgs, ...}: {
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
  };

  environment.systemPackages = with pkgs; [
    gamescope-wsi
  ];
}
