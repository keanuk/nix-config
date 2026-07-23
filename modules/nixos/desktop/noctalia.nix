{ inputs, ... }:
{
  flake.modules.nixos.noctalia = {
    imports = [
      inputs.noctalia.nixosModules.default
      inputs.noctalia-greeter.nixosModules.default
    ];

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };

    # greetd-based greeter; no display manager needed alongside it.
    programs.noctalia-greeter.enable = true;
  };
}
