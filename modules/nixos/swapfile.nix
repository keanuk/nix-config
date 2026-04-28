{
  flake.modules.nixos.swapfile = {
    swapDevices = [
      {
        device = "/swap/swapfile";
        priority = 0;
      }
    ];
  };
}
