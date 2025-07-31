{inputs, ...}: {
  imports = [
    inputs.preservation.nixosModules.preservation
  ];

  preservation = {
    enable = true;
  };
}
