# FIXME: calibre 9.13.0 fails to build due to ffmpeg 8/9 API removal and FileExistsError in polish test cache creation.
# Description: Override calibre's ffmpeg input to ffmpeg_7 and patch get_cache in polish tests to use os.makedirs(cache, exist_ok=True).
# Status: Active workaround
# Last checked: 2026-08-14
# Removal condition: Remove when nixpkgs updates or patches calibre.

_final: prev: {
  calibre =
    (prev.calibre.override {
      ffmpeg = prev.ffmpeg_7;
    }).overrideAttrs
      (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace src/calibre/ebooks/oeb/polish/tests/base.py \
            --replace-fail "os.mkdir(cache)" "os.makedirs(cache, exist_ok=True)"
        '';
      });
}
