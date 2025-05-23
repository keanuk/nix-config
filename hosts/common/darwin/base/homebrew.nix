{...}: {
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    masApps = {
      "Affinity Designer" = 824171161;
      "Affinity Photo" = 824183456;
      "Amphetamine" = 937984704;
      "Apple Configurator" = 1037126344;
      "Apple Developer" = 640199958;
      "Bitwarden" = 1352778147;
      "Dark Reader for Safari" = 1438243180;
      "Fakespot for Safari®" = 1592541616;
      "GarageBand" = 682658836;
      "iMovie" = 408981434;
      "Kagi for Safari" = 1622835804;
      "Keynote" = 409183694;
      "Messenger" = 1480068668;
      "NextDNS" = 1464122853;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Pixelmator Pro" = 1289583905;
      "Save to Pocket" = 1477385213;
      "Save to Reader" = 1640236961;
      "Shazam: Identify Songs" = 897118787;
      "Slack for Desktop" = 803453959;
      "Steam Link" = 1246969117;
      "Tailscale" = 1475387142;
      "Telegram" = 747648890;
      "TestFlight" = 899247664;
      "Transporter" = 1450874784;
      "Unsplash Wallpapers" = 1284863847;
      "WhatsApp Messenger" = 310633997;
      "Wipr" = 1320666476;
      "WireGuard" = 1451685025;
      "Xcode" = 497799835;
    };
    taps = [];
    brews = [];
    casks = [
      "battle-net"
      "beeper"
      "calibre"
      "chromium"
      "deepl"
      "discord"
      "docker"
      "ea"
      "element"
      "ente"
      "ente-auth"
      "epic-games"
      "ghostty"
      "gimp"
      "github@beta"
      "gog-galaxy"
      "google-drive"
      "handbrake"
      "kdenlive"
      "kodi"
      "libreoffice"
      "logi-options+"
      "nvidia-geforce-now"
      "obs"
      "ollamac"
      "orion"
      "plex"
      "pocket-casts"
      "podman-desktop"
      "proton-drive"
      "proton-mail"
      "proton-pass"
      "proton-mail-bridge"
      "protonvpn"
      "reader"
      "standard-notes"
      "steam"
      "virtualbox"
      "zen-browser"
    ];
  };
}
