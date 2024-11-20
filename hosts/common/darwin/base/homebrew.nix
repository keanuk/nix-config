{ ... }:

{
  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask"
      "homebrew/core"
    ];
    brews = [];
    casks = [
      "beeper"
      "chromium"
      "firefox"
      "firefox@developer-edition"
      "github@beta"
      "google-drive"
      "iterm2@beta"
      "jetbrains-toolbox"
      "proton-drive"
      "proton-mail"
      "proton-pass"
      "protonmail-bridge"
      "skype@preview"
      "standard-notes"
      "steam"
      "thunderbird"
      "thunderbird@beta"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "zed"
      "zed@preview"
    ];
  };
}
