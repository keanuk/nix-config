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
      "iterm2@beta"
      "proton-mail"
      "protonmail-bridge"
      "standard-notes"
      "thunderbird"
      "thunderbird@beta"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "zed"
      "zed@preview"
    ];
  };
}
