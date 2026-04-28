{
  flake.modules.nixos.amd =
    { pkgs, lib, ... }:
    {
      boot.kernelParams = [ "amdgpu.exp_hw_support=1" ];

      services = {
        ollama.package = lib.mkForce pkgs.unstable.ollama-rocm;
        xserver.videoDrivers = [ "amdgpu" ];
      };

      hardware.graphics.extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];

      environment.systemPackages = with pkgs; [
        radeontop
      ];

      nixpkgs.config.rocmSupport = true;
    };
}
