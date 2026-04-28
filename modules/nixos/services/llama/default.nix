{
  flake.modules.nixos.llama =
    { pkgs, ... }:
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp;
      };
    };
}
