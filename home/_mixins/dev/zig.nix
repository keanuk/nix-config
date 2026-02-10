{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zig
    # TODO: re-enable when build issues are resolved
    # zls
  ];
}
