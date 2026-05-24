final: prev: {
  matio = prev.matio.overrideAttrs (oldAttrs: {
    postFixup =
      (oldAttrs.postFixup or "")
      + prev.lib.optionalString prev.stdenv.isDarwin ''
        for f in $out/lib/*.dylib; do
          if [ ! -L "$f" ]; then
            install_name_tool -change "@rpath/libhdf5.310.dylib" "${final.hdf5}/lib/libhdf5.310.dylib" "$f"
          fi
        done
      '';
  });
}
