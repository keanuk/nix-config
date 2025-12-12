{
  config,
  lib,
  pkgs,
  ...
}: let
  domain = "oranos.me";
in {
  # OpenSMTPd - simple and secure mail transfer agent
  # Configured as a minimal local relay for outbound mail only
  services.opensmtpd = {
    enable = true;
    setSendmail = true;
    serverConfiguration = ''
      # Tables
      table aliases file:/etc/mail/aliases

      # Listen only on localhost - no external connections
      listen on localhost

      # Actions
      action "local_mail" mbox alias <aliases>
      action "outbound" relay helo ${domain}

      # Matching rules
      match for local action "local_mail"
      match from local for any action "outbound"
    '';
  };

  # Aliases file
  environment.etc."mail/aliases" = {
    text = ''
      # Basic aliases
      postmaster: root
      abuse: root
      root: keanu
    '';
    mode = "0644";
  };
}
