{ config, inputs, ... }:
let
  inherit (config.flake.modules.nixos)
    nix-settings
    system-packages
    sops
    tailscale
    nh
    ;
in
{
  # Deliberate standalone profile (like the homeManager profiles): WSL hosts
  # cannot take all of `base` (boot/initrd, disko, determinate), so this role
  # composes the base-adjacent features mars needs directly.
  flake.modules.nixos.wsl =
    { lib, ... }:
    {
      imports = [
        nix-settings
        system-packages
        sops
        tailscale
        nh
        inputs.wsl.nixosModules.default
        inputs.nur.modules.nixos.default
      ];

      wsl.enable = true;
      wsl.defaultUser = "keanu";

      # WSL does not have SSH host keys by default, so sops-nix cannot derive
      # an age key from them. Use the user's SSH key instead.
      sops.age.sshKeyPaths = lib.mkForce [ "/home/keanu/.ssh/id_ed25519" ];
    };
}
