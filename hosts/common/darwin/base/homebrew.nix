{ ... }:

{
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
        autoUpdate = true;
        cleanup = "uninstall";
        upgrade = true;
    };
    masApps = { };
    taps = [
      "homebrew/cask"
      "homebrew/core"
    ];
    brews = [ ];
    casks = [
      "alacritty"
      "audacity"
      "battle-net"
      "beeper"
      "bitwarden"
      "bruno"
      "calibre"
      "chromium"
      "cmake"
      "darktable"
      "dbeaver-community"
      "discord"
      "docker"
      "element"
      "epic-games"
      "firefox"
      "firefox@developer-edition"
      "ghostty"
      "gimp"
      "github@beta"
      "google-drive"
      "handbrake"
      "insomnia"
      "iterm2@beta"
      "jetbrains-toolbox"
      "kdenlive"
      "kitty"
      "libreoffice"
      "logi-options+"
      "messenger"
      "microsoft-teams"
      "nvidia-geforce-now"
      "obs"
      "podman-desktop"
      "postman"
      "proton-drive"
      "proton-mail"
      "proton-pass"
      "protonmail-bridge"
      "protonvpn"
      "reader"
      "signal"
      "skype@preview"
      "slack@beta"
      "standard-notes"
      "steam"
      "tailscale"
      "telegram"
      "thunderbird"
      "thunderbird@beta"
      "transmission"
      "virtualbox"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "vlc"
      "vscodium"
      "whatsapp"
      "wireshark"
      "zed"
      "zed@preview"
      "zen-browser"
      "zoom"
    ];
  };
}
