{ config, ... }:
{
  # The `dev` role owns a small set of cross-language tooling (formatters,
  # generic LSPs, devenv) that lives here rather than under any specific
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

  # The `dev` role itself opts into the `desktop` role so that desktop
  # hosts automatically get every language toolchain plus the cross-language
  # tooling above.
  flake.modules.homeManager.desktop = config.flake.modules.homeManager.dev;
}
