# FIXME: nixpkgs removed node20 from the default github-runner nodeRuntimes because
#   nodejs_20 reached EOL. However, many GitHub Actions (e.g., actions/checkout@v4)
#   still require node20 at runtime. Without it, the runner fails with:
#   "No such file or directory" for lib/externals/node20/bin/node.
# Issue: https://github.com/NixOS/nixpkgs/issues/355919 (related)
# Description: Restore node20 to github-runner's bundled node runtimes alongside node24.
#   Requires permittedInsecurePackages for nodejs_20 (already set in the github-runner module).
# Status: Active workaround
# Last checked: 2026-06-03
# Removal condition: Remove when all used GitHub Actions support node24 exclusively
#   and node20 is no longer required by the runner.

_final: prev: {
  github-runner = prev.github-runner.override {
    nodeRuntimes = [
      "node20"
      "node24"
    ];
  };
}
