{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        nixos-anywhere = inputs.nixos-anywhere.packages.${system}.default;
        deploy-rs = inputs.deploy-rs.packages.${system}.default;
      };
    };
}
