{ inputs, ... }:
{
  imports = [
    inputs.vscode-server.nixosModules.default

    # TODO: re-enable when RAID issues are resolved
    # ../services/authelia
    # ../services/cloudflared
    # ../services/cockpit
    # ../services/flaresolverr
    # ../services/forgejo
    # ../services/dashy
    # ../services/home-assistant
    # ../services/immich
    # ../services/nextcloud
    # ../services/nixarr
    # ../services/ollama
    # ../services/openssh
    # ../services/openvscode-server
    # ../services/open-webui
    ../services/smartd
  ];

  services.vscode-server.enable = true;
}
