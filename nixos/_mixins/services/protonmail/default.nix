{pkgs, ...}: {


  environment.systemPackages = with pkgs; [
    protonmail-bridge
    pass
    gnupg
  ];

  services.passSecretService.enable = true;

    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

  services.dbus.enable = true;

  systemd.user.services.protonmail-bridge = {
    description = "Protonmail Bridge SMTP/IMAP service";
    wantedBy = ["default.target"];
    after = ["network-online.target" "gpg-agent.service" "dbus.service"];
    wants = ["network-online.target"];

    path = [pkgs.pass pkgs.gnupg];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive --log-level info";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
