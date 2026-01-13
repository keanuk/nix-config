# GNOME Shell crashes when connecting Bluetooth headphones (SIGABRT in gvc_mixer_stream_get_port)
# Issue: https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/8961
# Upstream PR: None yet - libgvc bug in gvc-mixer-stream.c:535
# Workaround: Patch gvc_mixer_stream_get_port to return NULL instead of g_assert_not_reached()
#             when the port is not found in the ports list (can happen during Bluetooth device transitions)
# Status: temporary - waiting for upstream fix in GNOME Shell's libgvc
# Last checked: 2026-01-12
# Remove after: GNOME Shell > 49.2 or when upstream issue #8961 is resolved
_final: prev: {
  gnome-shell = prev.gnome-shell.overrideAttrs (oldAttrs: {
    # Patch libgvc to handle missing ports gracefully instead of aborting
    postPatch =
      (oldAttrs.postPatch or "")
      + ''
        # Fix gvc_mixer_stream_get_port crash when port not found in list
        # This happens when Bluetooth devices connect and ports are in transition
        substituteInPlace subprojects/gvc/gvc-mixer-stream.c \
          --replace-fail 'g_assert_not_reached ();' 'return NULL;'
      '';
  });

  # gnome-settings-daemon also uses libgvc and crashes with the same bug
  gnome-settings-daemon = prev.gnome-settings-daemon.overrideAttrs (oldAttrs: {
    postPatch =
      (oldAttrs.postPatch or "")
      + ''
        # Fix gvc_mixer_stream_get_port crash when port not found in list
        substituteInPlace subprojects/gvc/gvc-mixer-stream.c \
          --replace-fail 'g_assert_not_reached ();' 'return NULL;'
      '';
  });

  # TODO: Remove this workaround after GNOME Shell > 49.2 or upstream fix lands
}
