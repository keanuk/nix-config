{ config, ... }:
{
  # The `dev` role owns a small set of cross-language tooling (formatters,
  # generic LSPs, devenv) that lived directly in the original
  # home/_mixins/dev/default.nix aggregator rather than under any specific
  # language. Each language toolchain in modules/home/dev/<lang>/ also opts
  # itself into this role.
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        awk-language-server
        bash-language-server
        devenv
        gcc
        prettier
        shellcheck
      ];
    };

  # The `dev` role itself opts into the `desktop` role, matching the
  # original mixin behaviour where home/_mixins/desktop/default.nix
  # imported ../dev directly. Desktop hosts therefore automatically get
  # every language toolchain plus the cross-language tooling above.
  flake.modules.homeManager.desktop = config.flake.modules.homeManager.dev;
}
