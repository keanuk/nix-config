{
  pkgs,
  lib,
  ...
}: {
  # Enable AMD GPU drivers
  services = {
    ollama.package = lib.mkForce pkgs.ollama-rocm;
    xserver.videoDrivers = ["amdgpu"];
  };
  
  # OpenCL tools
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  environment.systemPackages = with pkgs; [
    radeontop
  ];

  nixpkgs.config.rocmSupport = true;
}
