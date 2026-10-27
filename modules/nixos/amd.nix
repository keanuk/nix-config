{ inputs, ... }:
{
  flake.modules.nixos.amd =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-pc
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];

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

      # TODO: Look into if this is still required;
      # it currently forces several large packages
      # to be fully rebuilt, causing build times
      # that are many hours long
      # nixpkgs.config.rocmSupport = true;
    };
}
