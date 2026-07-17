# FIXME: nix-openclaw builds the gateway with nodejs_22, and OpenClaw 2026.7.1
#        refuses to start when Node's SQLite is affected by the upstream
#        WAL-reset database corruption bug:
#          "OpenClaw requires SQLite 3.51.3+ (or patched 3.50.7+/3.44.6+)"
#        nixpkgs builds Node against the system sqlite, and nixos-25.11 ships
#        sqlite 3.51.2, so on stable-channel hosts (ursa) the gateway
#        crash-loops at startup. Run the gateway with nodejs_24 built against
#        sqlite >= 3.51.3; on stable hosts take it from the unstable package
#        set (Hydra-cached, avoids a full Node rebuild).
#        The outer callPackage swallows a direct `nodejs_22` override, and the
#        home-manager module resolves its instance package through
#        openclawPackages.withTools, so both entry points are patched here.
# Issue: https://github.com/openclaw/nix-openclaw/issues (no dedicated issue yet;
#   packaging pins nodejs_22 in nix/packages/openclaw-gateway-npm.nix)
# Status: Active workaround
# Last checked: 2026-07-17
# Removal condition: Remove when the stable channel ships sqlite >= 3.51.3 and
#   nix-openclaw builds the gateway with a Node whose SQLite is safe.

final: prev:
let
  inherit (prev) lib;

  # nixpkgs builds Node against the system sqlite; only stable-channel
  # package sets (sqlite < 3.51.3) need the workaround.
  sqliteSafe = lib.versionAtLeast prev.sqlite.version "3.51.3";
  node = (final.unstable or { }).nodejs_24 or final.nodejs_24;

  fixGateway =
    gateway:
    if sqliteSafe then
      gateway
    else
      gateway.overrideAttrs (old: {
        env = (old.env or { }) // {
          NODE_BIN = "${node}/bin/node";
        };
      });

  fixBundle =
    bundle: gateway: if sqliteSafe then bundle else bundle.override { openclaw-gateway = gateway; };
in
lib.optionalAttrs (prev ? openclawPackages) (
  let
    gateway = fixGateway prev.openclaw-gateway;
    bundle = fixBundle prev.openclaw gateway;
  in
  {
    openclaw-gateway = gateway;
    openclaw = bundle;
    openclawPackages = prev.openclawPackages // {
      openclaw-gateway = gateway;
      openclaw = bundle;
      withTools =
        args:
        let
          built = prev.openclawPackages.withTools args;
          toolGateway = fixGateway built.openclaw-gateway;
        in
        built
        // {
          openclaw-gateway = toolGateway;
          openclaw = fixBundle built.openclaw toolGateway;
        };
    };
  }
)
