{ inputs, pkgs, ... }:

{
  nix-homebrew = {
    enable = true;
    user = "keanu";

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
    mutableTaps = false;
  };
}
