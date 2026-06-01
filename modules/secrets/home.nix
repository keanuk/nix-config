{ config, inputs, ... }:
let
  sopsFile = config._module.args.rootPath + "/secrets/sops/secrets.yaml";
in
{
  flake.modules.homeManager.sops =
    { config, lib, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = sopsFile;
        defaultSopsFormat = "yaml";

        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

        secrets = {
          github-token = { };
        };
      };

      programs = {
        fish.interactiveShellInit = lib.mkIf (config.sops.secrets ? github-token) (
          lib.mkBefore ''
            set -gx NIX_GITHUB_TOKEN (cat ${config.sops.secrets.github-token.path})
          ''
        );

        zsh.initExtra = lib.mkIf (config.sops.secrets ? github-token) (
          lib.mkBefore ''
            export NIX_GITHUB_TOKEN=$(cat ${config.sops.secrets.github-token.path})
          ''
        );

        bash.initExtra = lib.mkIf (config.sops.secrets ? github-token) (
          lib.mkBefore ''
            export NIX_GITHUB_TOKEN=$(cat ${config.sops.secrets.github-token.path})
          ''
        );
      };
    };
}
