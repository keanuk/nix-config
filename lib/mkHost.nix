# Helper function to create consistent home-manager configurations
#
# Usage in NixOS/Darwin host configs:
#
#   imports = [
#     (lib.mkHomeManagerHost {
#       inherit inputs outputs;
#       users.keanu = ../../home/titan/keanu.nix;
#     })
#   ];
#
# For multiple users:
#   (lib.mkHomeManagerHost {
#     inherit inputs outputs;
#     users = {
#       keanu = ../../home/hyperion/keanu.nix;
#       kimmy = ../../home/hyperion/kimmy.nix;
#     };
#   })
{
  inputs,
  outputs,
  users,
  ...
}:
let
  userConfigs = builtins.mapAttrs (username: homeModule: {
    imports = [ homeModule ];
  }) users;
in
{
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    users = userConfigs;
  };
}
