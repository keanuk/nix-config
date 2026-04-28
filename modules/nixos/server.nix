{ inputs, ... }:
{
  # The full server stack (authelia, cloudflared, cockpit, forgejo, dashy,
  # home-assistant, immich, nextcloud, nixarr, ollama, openssh,
  # openvscode-server, open-webui, smartd) opts itself into the `server`
  # role from each service's own file. Only inline config that doesn't
  # belong to a single service lives here.
  flake.modules.nixos.server = {
    imports = [ inputs.vscode-server.nixosModules.default ];

    services.vscode-server.enable = true;
  };
}
