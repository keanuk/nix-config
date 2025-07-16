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
      "GarageBand" = 682658836;
      "HacKit" = 1549557075;
      "iMovie" = 408981434;
      "Kagi for Safari" = 1622835804;
      "Keynote" = 409183694;
      "Messenger" = 1480068668;
      "NextDNS" = 1464122853;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Pixelmator Pro" = 1289583905;
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
    taps = [
      "th-ch/youtube-music"
    ];
    brews = [];
    casks = [
      "alacritty"
      "audacity"
      "battle-net"
      "bruno"
      "calibre"
      "chromium"
      "darktable"
      "dbeaver-community"
      "deepl"
      "discord"
      "docker-desktop"
      "ea"
      "element"
      "ente"
      "ente-auth"
      "epic-games"
      "firefox"
      "firefox@developer-edition"
      {
        name = "ghostty";
        args = {appdir = "/Applications";};
      }
      "gimp"
      "github@beta"
      "gog-galaxy"
      "google-chrome"
      "google-chrome@beta"
      "google-chrome@canary"
      "google-chrome@dev"
      "google-drive"
      "halloy"
      "handbrake-app"
      "insomnia"
      "kdenlive"
      "kitty"
      "kodi"
      "libreoffice"
      "logi-options+"
      "logseq"
      "nvidia-geforce-now"
      "obs"
      "ollamac"
      {
        name = "orion";
        args = {appdir = "/Applications";};
      }
      "plex"
      "pocket-casts"
      "podman-desktop"
      {
        name = "proton-drive";
        args = {appdir = "/Applications";};
      }
      "proton-mail"
      "proton-pass"
      "proton-mail-bridge"
      "protonvpn"
      "reader"
      "rustdesk"
      "signal"
      "standard-notes"
      "stats"
      "steam"
      "thunderbird"
      "thunderbird@beta"
      "transmission"
      "virtualbox"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "vlc"
      "youtube-music"
      {
        name = "zed";
        args = {appdir = "/Applications";};
      }
      {
        name = "zen";
        args = {appdir = "/Applications";};
      }

      # Games
      "0-ad"
      "bugdom"
      "bugdom2"
      "cro-mag-rally"
      "nanosaur"
      "nanosaur2"
      "otto-matic"
      "shattered-pixel-dungeon"
      "superTuxKart"
      "the-battle-for-wesnoth"
      "xonotic"
    ];
  };
}
