{ pkgs, inputs, outputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.home-manager.darwinModules.home-manager
    ../common/darwin/default.nix
  ];

  networking.hostName = "phoenix";

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.keanu = {
      imports = [ ../../home/phoenix.nix ];
      home.stateVersion = "24.05";
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixUnstable;

  nixpkgs.hostPlatform = "x86_64-darwin";
  system.stateVersion = 4;
}
