{ ... }:

{
  imports = [
    ./shell/default.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home = {
    sessionVariables = {
      # EDITOR = "micro";
      # SYSTEMD_EDITOR = "micro";
      # VISUAL = "micro";
    };
  };
}
