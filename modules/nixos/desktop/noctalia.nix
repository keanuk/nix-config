{
  flake.modules.nixos.noctalia =
    {
      inputs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.noctalia.nixosModules.default
        inputs.noctalia-greeter.nixosModules.default
      ];

      programs.noctalia = {
        enable = lib.mkDefault true;
        recommendedServices.enable = lib.mkDefault true;
      };

      programs.noctalia-greeter = {
        enable = lib.mkDefault true;
      };

      security.pam.services.noctalia = { };

      services.displayManager.gdm.enable = lib.mkForce false;
    };
}
