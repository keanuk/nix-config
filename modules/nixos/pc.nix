{
  # smartd and openssh opts itself into pc from its own file.
  flake.modules.nixos.pc = {
    services.openssh.openFirewall = false;
  };
}
