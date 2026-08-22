_: {
  # Only inline server-specific config lives here; zellij, opencode, and pass
  # opt themselves into this role from their own files.
  flake.modules.homeManager.server =
    { pkgs, ... }:
    {
      programs.zellij = {
        enableZshIntegration = true;
        enableFishIntegration = true;
        exitShellOnExit = true;
      };

      home.packages = with pkgs; [
        transmission_4
      ];
    };
}
