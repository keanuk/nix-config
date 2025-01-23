{ pkgs, ... }:

{
  # Enable AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # OpenCL tools
  hardware.graphics.extraPackages = with pkgs; [
    # TODO: Re-enable when the build succeeds
    # rocmPackages.clr.icd
  ];

  environment.systemPackages = with pkgs; [
    radeontop
  ];
}
