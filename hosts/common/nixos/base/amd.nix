{ config, pkgs, ... }:

{
  # Enable AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # OpenCL tools
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  environment.systemPackages = with pkgs; [
    radeontop
  ];
}
