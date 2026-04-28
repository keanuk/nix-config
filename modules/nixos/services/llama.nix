{
  flake.modules.nixos.svc-llama =
    { pkgs, ... }:
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp;
      };
    };
}
