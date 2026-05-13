{ config, lib, ... }:
{
  flake.modules.nixos = {
    openssh = _: {
      services.openssh = {
        enable = true;
        ports = [ 22 ];
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
          X11Forwarding = false;
          MaxAuthTries = 3;
          LoginGraceTime = 30;
          AuthenticationMethods = "publickey";
        };
        openFirewall = lib.mkDefault true;
      };
    };

    server = config.flake.modules.nixos.openssh;
    pc = config.flake.modules.nixos.openssh;
    laptop = config.flake.modules.nixos.openssh;
  };
}
