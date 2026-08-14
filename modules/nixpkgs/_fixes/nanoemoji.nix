# FIXME: nanoemoji 0.16.0 in nixpkgs has a source hash mismatch.
# Description: Override nanoemoji's src hash to sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=.
# Status: Active workaround
# Last checked: 2026-08-13
# Removal condition: Remove when nixpkgs updates or fixes the hash for nanoemoji 0.16.0.

_final: prev: {
  pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
    (_pythonFinal: pythonPrev: {
      nanoemoji = pythonPrev.nanoemoji.overrideAttrs (oldAttrs: {
        src = oldAttrs.src.overrideAttrs (_: {
          outputHash = "sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=";
        });
      });
    })
  ];
}
