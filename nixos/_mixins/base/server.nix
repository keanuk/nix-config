{ inputs, ... }:
{
  imports = [
    inputs.vscode-server.nixosModules.default

    ../services/authelia
    ../services/cloudflared
    ../services/protonmail
    ../services/cockpit
    ../services/flaresolverr
    ../services/gitlab
    ../services/dashy
    ../services/home-assistant
    ../services/immich
    ../services/nextcloud
    ../services/nixarr
    ../services/ollama
    ../services/openssh
    ../services/openvscode-server
    ../services/open-webui
    ../services/smartd
  ];

  services.vscode-server.enable = true;
}
