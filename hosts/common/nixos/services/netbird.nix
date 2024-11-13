{ pkgs, ... }:

{
  services.netbird = {
    enable = true;
    package = pkgs.unstable.netbird;
  };

  users.users.keanu.packages = with pkgs; [
    netbird-dashboard
    netbird-ui
  ];
}
