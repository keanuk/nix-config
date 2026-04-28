{ config, inputs, ... }:
{
  flake.modules.nixos.wsl = {
    imports = (
      with config.flake.modules.nixos;
      [
        nix-settings
        system-packages
        svc-comin
        svc-tailscale
        prog-nh
      ]
    )
    ++ [
      inputs.wsl.nixosModules.default
      inputs.nur.modules.nixos.default
    ];

    wsl.enable = true;
    wsl.defaultUser = "keanu";
  };
}
