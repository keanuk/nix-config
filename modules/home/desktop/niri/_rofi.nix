{
  pkgs,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    cycle = false;
    location = "center";
    terminal = "alacritty";
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };
    theme = "theme";
  };

  home.file.".config/rofi/themes/rofi-mocha.rasi".text = ''
    * {
      bg: #1e1e2e;
      fg: #cdd6f4;
      bg-alt: #313244;
      fg-alt: #a6adc8;
      highlight: #89b4fa;
      urgent: #f38ba8;
      transparent: rgba(0,0,0,0);
    }

    window {
      width: 600px;
      border: 2px;
      border-color: @highlight;
      background-color: @bg;
      padding: 12px;
    }

    mainbox {
      spacing: 10px;
      padding: 0;
      background-color: @transparent;
      children: [ inputbar, listview ];
    }

    inputbar {
      spacing: 8px;
      padding: 8px 12px;
      background-color: @bg-alt;
      border-radius: 8px;
      children: [ prompt, entry ];
    }

    prompt {
      text-color: @highlight;
      font: "RobotoMono Nerd Font 14";
    }

    entry {
      text-color: @fg;
      placeholder: "Search...";
      placeholder-color: @fg-alt;
      font: "Roboto 14";
    }

    listview {
      lines: 10;
      spacing: 6px;
      padding: 0;
      background-color: @transparent;
      fixed-height: false;
      dynamic: true;
    }

    element {
      padding: 8px 12px;
      spacing: 8px;
      border-radius: 8px;
      background-color: @transparent;
      text-color: @fg;
    }

    element selected {
      background-color: @bg-alt;
      text-color: @highlight;
    }

    element-icon {
      size: 24px;
    }

    element-text {
      font: "Roboto 14";
    }

    mode-switcher {
      spacing: 8px;
    }

    button {
      padding: 6px 12px;
      border-radius: 8px;
      background-color: @bg-alt;
      text-color: @fg-alt;
    }

    button selected {
      background-color: @highlight;
      text-color: @bg;
    }
  '';

  home.file.".config/rofi/themes/rofi-latte.rasi".text = ''
    * {
      bg: #eff1f5;
      fg: #4c4f69;
      bg-alt: #ccd0da;
      fg-alt: #6c6f85;
      highlight: #1e66f5;
      urgent: #d20f39;
      transparent: rgba(0,0,0,0);
    }

    window {
      width: 600px;
      border: 2px;
      border-color: @highlight;
      background-color: @bg;
      padding: 12px;
    }

    mainbox {
      spacing: 10px;
      padding: 0;
      background-color: @transparent;
      children: [ inputbar, listview ];
    }

    inputbar {
      spacing: 8px;
      padding: 8px 12px;
      background-color: @bg-alt;
      border-radius: 8px;
      children: [ prompt, entry ];
    }

    prompt {
      text-color: @highlight;
      font: "RobotoMono Nerd Font 14";
    }

    entry {
      text-color: @fg;
      placeholder: "Search...";
      placeholder-color: @fg-alt;
      font: "Roboto 14";
    }

    listview {
      lines: 10;
      spacing: 6px;
      padding: 0;
      background-color: @transparent;
      fixed-height: false;
      dynamic: true;
    }

    element {
      padding: 8px 12px;
      spacing: 8px;
      border-radius: 8px;
      background-color: @transparent;
      text-color: @fg;
    }

    element selected {
      background-color: @bg-alt;
      text-color: @highlight;
    }

    element-icon {
      size: 24px;
    }

    element-text {
      font: "Roboto 14";
    }

    mode-switcher {
      spacing: 8px;
    }

    button {
      padding: 6px 12px;
      border-radius: 8px;
      background-color: @bg-alt;
      text-color: @fg-alt;
    }

    button selected {
      background-color: @highlight;
      text-color: @bg;
    }
  '';
}
