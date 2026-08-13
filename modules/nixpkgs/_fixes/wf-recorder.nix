# FIXME: wf-recorder 0.6.0 fails to build against ffmpeg 8/9 because libavcodec
#   removed deprecated AVCodec struct members (codec->sample_fmts).
# Description: Override wf-recorder's ffmpeg input to ffmpeg_7 so it builds successfully.
# Status: Active workaround
# Last checked: 2026-08-13
# Removal condition: Remove when nixpkgs updates or patches wf-recorder for ffmpeg 8+.

_final: prev: {
  wf-recorder = prev.wf-recorder.override {
    ffmpeg = prev.ffmpeg_7;
  };
}
