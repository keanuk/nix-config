{
  flake.modules.nixos.noctalia =
    {
      pkgs,
      inputs,
      lib,
      ...
    }:
    {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      networking.networkmanager.enable = lib.mkDefault true;
      hardware.bluetooth.enable = lib.mkDefault true;
      services.power-profiles-daemon.enable = lib.mkDefault true;
      services.upower.enable = lib.mkDefault true;
    };
}
