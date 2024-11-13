{ pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  users.users.keanu.packages = with pkgs; [
    trayscale
  ];
}
