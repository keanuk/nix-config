{
  config,

  lib,
  ...
}:

{
  services.nix-config.github-runner = {
    enable = lib.mkDefault true;
    tokenFile = config.sops.secrets.github-runner-token.path;
  };

  sops.secrets.github-runner-token = {
    owner = "github-runner";
    mode = "0400";
  };
}
