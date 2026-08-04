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
        # logind ignores the lid switch for 30s (default) after boot/resume to
        # let USB docks enumerate; cut it down so a lid close right after a
        # quick wake still suspends.
        HoldoffTimeoutSec = 5;
      };
    };
  };
}
