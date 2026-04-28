{ config, inputs, ... }:
{
  flake.modules.nixos.server = {
    imports = (
      with config.flake.modules.nixos;
      [
        svc-authelia
        svc-cloudflared
        svc-cockpit
        svc-forgejo
        svc-dashy
        svc-home-assistant
        svc-immich
        svc-nextcloud
        svc-nixarr
        svc-ollama
        svc-openssh
        svc-openvscode-server
        svc-open-webui
        svc-smartd
      ]
    )
    ++ [ inputs.vscode-server.nixosModules.default ];

    services.vscode-server.enable = true;
  };
}
