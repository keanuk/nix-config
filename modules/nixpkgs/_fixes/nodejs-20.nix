# FIXME: nodejs_20 reached end-of-life and is marked insecure in nixpkgs.
#        The check phase contains flaky tests (test-child-process-stdout-flush-exit.js)
#        that fail non-deterministically during build.
# Issue: https://github.com/NixOS/nixpkgs/issues/355919
# Description: Disable the check phase for nodejs_20 and nodejs-slim_20 to avoid
#   flaky test failures. Required by the github-runner package which depends on nodejs_20.
# Status: Active workaround
# Last checked: 2025-06-05
# Removal condition: Remove when github-runner in nixpkgs upgrades to nodejs_22
#   or when nodejs_20 is no longer required.

_final: prev: {
  nodejs_20 = prev.nodejs_20.overrideAttrs (_oldAttrs: {
    doCheck = false;
  });

  nodejs-slim_20 = prev.nodejs-slim_20.overrideAttrs (_oldAttrs: {
    doCheck = false;
  });
}
