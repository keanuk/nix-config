{ pkgs, inputs, lib, ... }:

{
  # systemd.user.services.hyprpaper = {
  #   Unit = {
  #     Description = "Hyprland wallpaper daemon";
  #     PartOf = ["graphical-session.target"];
  #   };
  #   Service = {
  #     ExecStart = "${lib.getExe inputs.hyprpaper.packages.${pkgs.system}.default}";
  #     Restart = "on-failure";
  #   };
  # };
}
