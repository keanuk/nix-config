# sops-nix Home Manager integration for Darwin hosts
#
# Mirrors nixos/_mixins/base/sops.nix but uses the Home Manager module
# instead of the NixOS module. Decrypts secrets to ~/.config/sops-nix/secrets/
{ inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets/sops/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
