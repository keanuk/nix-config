{
  flake.modules.nixos.prog-nh =
    {
      pkgs,
      config,
      ...
    }:
    {
      programs.nh = {
        enable = true;
        package = pkgs.nh;
        flake = "${config.users.users.keanu.home}/.config/nix-config";
        clean.enable = false;
      };

      environment.variables.NH_NO_CHECKS = 1;
    };
}
