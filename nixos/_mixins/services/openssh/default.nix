{ lib, ... }:
{
  services.openssh = {
    enable = true;
    ports = [
      22
    ];
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
}
