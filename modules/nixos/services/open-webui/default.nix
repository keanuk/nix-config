{ config, ... }:
let
  d = config.domains;
in
{
  flake.modules.nixos.open-webui =
    { pkgs, ... }:
    {
      services.open-webui = {
        enable = true;
        # Pinned to stable: unstable's python3Packages.posthog is marked broken
        # (incompatible with mcp >= 2, see nixpkgs pkgs/development/python-modules/
        # posthog/default.nix), which makes pkgs.unstable.open-webui unevaluable.
        # Removal condition: switch back to pkgs.unstable.open-webui once posthog
        # builds against mcp 2.
        # Last-checked: 2026-10-26
        package = pkgs.stable.open-webui;
        # Exposed on the tailnet for direct use (open-webui has its own login);
        # web access goes through the Authelia proxy.
        openFirewall = true;
        host = "0.0.0.0";
        port = d.services.chat.backendPort;
      };
    };

  flake.modules.nixos.server = config.flake.modules.nixos.open-webui;
}
