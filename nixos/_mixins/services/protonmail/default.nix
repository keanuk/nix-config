{pkgs, ...}: {
  # Protonmail Bridge for SMTP relay
  #
  # ============================================================================
  # SETUP INSTRUCTIONS (one-time interactive setup required):
  # ============================================================================
  #
  # 1. First, ensure you have a GPG key set up:
  #    $ gpg --gen-key
  #    (Follow the prompts to create a key)
  #
  # 2. Initialize pass with your GPG key:
  #    $ pass init <your-gpg-key-id>
  #
  # 3. After rebuilding NixOS, run as your user:
  #    $ protonmail-bridge --cli
  #
  # 4. At the bridge prompt, log in:
  #    >>> login
  #    (Follow the prompts to enter your Protonmail credentials)
  #
  # 5. After successful login, get your bridge credentials:
  #    >>> info
  #    This will show you:
  #    - SMTP Server: 127.0.0.1:1025
  #    - Username: (your protonmail email)
  #    - Password: (bridge-generated password - NOT your Protonmail password)
  #
  # 6. Add the bridge password to SOPS:
  #    $ sops secrets/sops/secrets.yaml
  #    Add: protonmail-bridge-password: <the bridge password from step 5>
  #
  # 7. Exit the bridge CLI:
  #    >>> exit
  #
  # 8. Enable lingering for your user (allows user services to run at boot):
  #    $ sudo loginctl enable-linger $USER
  #
  # 9. Start the user service:
  #    $ systemctl --user enable --now protonmail-bridge
  #
  # 10. Rebuild NixOS to apply Authelia SMTP changes:
  #    $ sudo nixos-rebuild switch --flake .
  #
  # ============================================================================

  environment.systemPackages = with pkgs; [
    protonmail-bridge
    pass
    gnupg
  ];

  # Enable the pass secret service at the system level
  # This provides the D-Bus secret service API that Protonmail Bridge uses
  services.passSecretService.enable = true;

  # Enable GPG agent for pass to work
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # Enable extra socket for forwarding
    enableExtraSocket = true;
  };

  # Enable D-Bus (required for secret service)
  services.dbus.enable = true;

  # User service for protonmail-bridge
  # Runs as the logged-in user to access credentials stored during interactive setup
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
