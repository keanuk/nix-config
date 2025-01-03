{ config, pkgs, ... }:

{
  # Enable AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # OpenCL tools
  hardware.graphics.extraPackages = with pkgs; [
    # rocmPackages.clr.icd
  ];

  environment.systemPackages = with pkgs; [
    radeontop
  ];
}
