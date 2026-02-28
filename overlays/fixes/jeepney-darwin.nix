# yt-dlp pulls in secretstorage → jeepney on Darwin, but jeepney needs D-Bus
# which is not available on macOS. The secretstorage optional dependency is
# only useful on Linux (freedesktop Secret Service API).
#
# Issue: jeepney's installCheckPhase/pythonImportsCheckPhase fails on macOS
# Error: "dbus-run-session: EOF reading address from bus daemon"
#    or: "ModuleNotFoundError: No module named 'outcome'" (when overrideScope breaks closure)
# Workaround: Override yt-dlp to drop the secretstorage optional-dependencies on Darwin
# Status: temporary - upstream nixpkgs should gate this dependency on Linux
# Last checked: 2025-07-27
# Remove after: nixpkgs gates yt-dlp's secretstorage dep on stdenv.hostPlatform.isLinux
_final: prev:
prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  yt-dlp = prev.yt-dlp.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs = builtins.filter (
      dep:
      !builtins.elem (dep.pname or "") [
        "secretstorage"
        "jeepney"
      ]
    ) (oldAttrs.propagatedBuildInputs or [ ]);
    dependencies = builtins.filter (
      dep:
      !builtins.elem (dep.pname or "") [
        "secretstorage"
        "jeepney"
      ]
    ) (oldAttrs.dependencies or [ ]);
  });
}
