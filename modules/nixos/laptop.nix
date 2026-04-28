{
  # smartd opts itself into laptop from its own file.
  flake.modules.nixos.laptop = {
    services = {
      thermald.enable = true;
    };
  };
}
