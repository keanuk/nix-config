{ config, ... }:
{
  # The `dev` role (the union of every modules/home/dev/<lang>/) opts itself
  # into the `desktop` role, matching the original mixin behaviour where
  # `home/_mixins/desktop/default.nix` imported `../dev` directly. Desktop
  # hosts therefore automatically get every language toolchain.
  flake.modules.homeManager.desktop = config.flake.modules.homeManager.dev;
}
