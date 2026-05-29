{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    nix-settings
    system-packages
    sops
    comin
    tailscale
    nh
    ;
in
{
  flake.modules.nixos.wsl = {
    imports = [
      nix-settings
      system-packages
      sops
      comin
      tailscale
      nh
      inputs.wsl.nixosModules.default
      inputs.nur.modules.nixos.default
    ];

    wsl.enable = true;
    wsl.defaultUser = "keanu";
  };
}
