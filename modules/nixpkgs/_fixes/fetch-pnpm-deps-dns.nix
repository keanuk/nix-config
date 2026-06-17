# FIXME: pnpm's parallel c-ares DNS lookups fail with EAI_AGAIN inside
#   the Nix build sandbox. Affects large pnpm-based FODs that need to be
#   built locally (e.g. element-web, authelia-web) on hosts where the
#   sandbox's resolver cannot satisfy pnpm's default 50-way concurrent
#   fetch. Host-level DNS works fine; curl from a FOD works fine. The
#   pattern points at pnpm's c-ares load on the resolver, not a network
#   block or sandbox path gap.
# Issue: not tracked upstream as a single bug; reproduced in
#   Determinate Nix 3.21.x and upstream Nix 2.34+ with systemd-resolved
#   on the host.
# Description: Wrap fetchPnpmDeps to (1) force Node's DNS resolver to
#   prefer IPv4 via --dns-result-order=ipv4first, skipping AAAA queries
#   that timeout, and (2) cap pnpm's fetch concurrency at 4 to avoid
#   overwhelming the sandbox's connection tracking / FD limits.
# Status: Active workaround
# Last checked: 2026-06-17
# Removal condition: Remove once pnpm-based FODs that need local builds
#   (element-web, authelia-web) are cached for the pinned nixpkgs rev,
#   or once the underlying c-ares-in-sandbox interaction is fixed.

_final: prev: {
  fetchPnpmDeps =
    args:
    prev.fetchPnpmDeps (
      args
      // {
        prePnpmInstall = ''
          export NODE_OPTIONS="--dns-result-order=ipv4first"
          export pnpm_config_fetch_concurrency=4
        ''
        + (args.prePnpmInstall or "");
      }
    );
}
