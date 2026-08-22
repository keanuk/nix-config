{ config, inputs, ... }:
{
  flake.modules.nixos.vscode-server = _: {
    imports = [ inputs.vscode-server.nixosModules.default ];

    services.vscode-server.enable = true;
  };

  flake.modules.nixos = {
    server = config.flake.modules.nixos.vscode-server;
    vps = config.flake.modules.nixos.vscode-server;
  };
}
