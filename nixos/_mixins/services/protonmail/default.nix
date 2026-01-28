{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    protonmail-bridge
    pass
    gnupg
  ];

  services.passSecretService.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

  services.dbus.enable = true;

  users.users.protonmail-bridge = {
    isSystemUser = true;
    group = "protonmail-bridge";
    home = "/var/lib/protonmail-bridge";
    createHome = true;
    description = "Protonmail Bridge system user";
  };

  users.groups.protonmail-bridge = { };

  systemd.services.protonmail-bridge = {
    description = "Protonmail Bridge SMTP/IMAP service";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "dbus.service"
    ];
    wants = [ "network-online.target" ];

    path = [
      pkgs.pass
      pkgs.gnupg
    ];

    serviceConfig = {
      Type = "simple";
      User = "protonmail-bridge";
      Group = "protonmail-bridge";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive --log-level info";
      Restart = "on-failure";
      RestartSec = "10s";
      StateDirectory = "protonmail-bridge";
    };
  };
}
