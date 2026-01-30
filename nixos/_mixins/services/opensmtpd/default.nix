_: {
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
      action "outbound" relay helo oranos.org

      # Matching rules
      match for local action "local_mail"
      match from local for any action "outbound"
    '';
  };
}
