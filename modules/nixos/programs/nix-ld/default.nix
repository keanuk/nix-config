{
  flake.modules.nixos.prog-nix-ld =
    { pkgs, ... }:
    {
      programs.nix-ld = {
        enable = true;
        package = pkgs.nix-ld;
      };
    };
}
