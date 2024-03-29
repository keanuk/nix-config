{ config, pkgs, ... }:

{
  # Enable AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Vulkan
  hardware.opengl.driSupport = true;

  # OpenCL tools
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  environment.systemPackages = with pkgs; [
    radeontop
  ];
}
