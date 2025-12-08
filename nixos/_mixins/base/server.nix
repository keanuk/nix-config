{lib, ...}: {
  imports = [
    ../services/cloudflared
    ../services/cockpit
    ../services/flaresolverr
    ../services/home-assistant
    ../services/immich
    ../services/nextcloud
    ../services/nixarr
    ../services/ollama
    ../services/openvscode-server
    ../services/open-webui
  ];

  # TODO: Figure out why audit isn't working on NixOS 25.11
  security = {
    audit.enable = lib.mkForce false;
    auditd.enable = lib.mkForce false;
  };
}
