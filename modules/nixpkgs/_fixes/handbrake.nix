# FIXME: handbrake 1.11.1 bundles contrib ffmpeg patches (A01-A24) that
#   target ffmpeg 8.0.x, but nixpkgs' ffmpeg_8-full advanced to 8.1.2, so
#   A01-mov-read-name-track-tag-written-by-movenc.patch fails in patchPhase
#   (mov.c context shifted), blocking the whole handbrake -> ffmpeg-full
#   -> home-manager-path -> user-environment -> etc chain.
# Issue: https://github.com/NixOS/nixpkgs/issues/540400
# Upstream PRs: https://github.com/NixOS/nixpkgs/pull/541043 (update bundled
#   contrib to 8.1.2), https://github.com/NixOS/nixpkgs/pull/541044 (pin
#   ffmpeg-hb to 8.0.2 -- this overlay mirrors the latter; build-confirmed
#   on x86_64-linux by nixpkgs-review in PR #541044).
# Description: Pin handbrake's ffmpeg_8-full input to 8.0.2 (matching the
#   contrib patches) only for handbrake; the rest of the system keeps ffmpeg
#   8.1.2. Avoids handbrake needing its own ffmpeg rebuild differently.
# Status: Active workaround
# Last checked: 2026-07-12
# Removal condition: Remove when nixpkgs merges a handbrake fix (PR #541043 or
#   #541044) and the pinned nixpkgs revision advances past it.

_final: prev: {
  handbrake = prev.handbrake.override {
    ffmpeg_8-full = prev.ffmpeg_8-full.override {
      version = "8.0.2";
      hash = "sha256-5um1aG+92tn7ykVU59sBKWEvg1egODfZr6XTp/kSaG4=";
    };
  };
}
