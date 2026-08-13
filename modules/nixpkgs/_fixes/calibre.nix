# FIXME: calibre 9.11.0 fails to build against ffmpeg 8/9 because libavcodec
#   removed deprecated AVCodec struct members (codec->sample_fmts).
# Description: Override calibre's ffmpeg input to ffmpeg_7 so it builds successfully.
# Status: Active workaround
# Last checked: 2026-08-13
# Removal condition: Remove when nixpkgs updates or patches calibre for ffmpeg 8+.

_final: prev: {
  calibre = prev.calibre.override {
    ffmpeg = prev.ffmpeg_7;
  };
}
