{
  # smartd and openssh opts itself into laptop from its own file.
  flake.modules.nixos.laptop = {
    services = {
      openssh.openFirewall = false;
      thermald.enable = true;
      logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
      };
    };
  };
}
