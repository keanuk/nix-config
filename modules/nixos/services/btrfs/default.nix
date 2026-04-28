{
  flake.modules.nixos.svc-btrfs = _: {
    services.btrfs = {
      autoScrub.enable = true;
    };
  };
}
