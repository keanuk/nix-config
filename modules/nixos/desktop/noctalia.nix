{ inputs, ... }:
{
  flake.modules.nixos.noctalia =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.noctalia.nixosModules.default
        inputs.noctalia-greeter.nixosModules.default
      ];

      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
      };

      # greetd-based greeter; no display manager needed alongside it.
      programs.noctalia-greeter.enable = true;

      # Noctalia's idle behaviors only fire on idle timeouts; also lock when sleep
      # is triggered directly (lid close, systemctl suspend, hibernate). Runs in
      # the pre-sleep phase of NixOS' built-in sleep-actions.service.
      powerManagement.powerDownCommands = "${lib.getExe' pkgs.systemd "loginctl"} lock-sessions";
    };
}
