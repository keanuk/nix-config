{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.element-desktop = {
        enable = true;
        # Workaround: pinned to stable because the unstable build failed at the time
        # (no upstream issue was recorded).
        # Status: active workaround
        # Last-checked: 2026-08-22
        # Removal condition: retry pkgs.unstable.element-desktop after each nixpkgs
        # bump and switch back once it builds.
        package = pkgs.stable.element-desktop;
      };
    };
}
