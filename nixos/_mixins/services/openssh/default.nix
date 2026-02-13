_: {
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
    };
  };
}
