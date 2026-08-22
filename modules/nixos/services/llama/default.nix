# NOTE: Not imported by any host; kept intentionally for future use.
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
