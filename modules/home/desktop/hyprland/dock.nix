{ config, ... }:
{
  home.file."${config.xdg.configHome}/nwg-dock-hyprland/themes/dark.css".text = ''
    window {
      background: rgba(30, 30, 46, 0.85);
      border-radius: 16px;
      border: 2px solid #89b4fa;
    }
    #box {
      padding: 6px;
    }
    button {
      padding: 4px;
      border-radius: 10px;
      background: transparent;
    }
    button:hover {
      background: rgba(137, 180, 250, 0.25);
    }
    image {
      padding: 2px;
    }
  '';

  home.file."${config.xdg.configHome}/nwg-dock-hyprland/themes/light.css".text = ''
    window {
      background: rgba(239, 241, 245, 0.9);
      border-radius: 16px;
      border: 2px solid #1e66f5;
    }
    #box {
      padding: 6px;
    }
    button {
      padding: 4px;
      border-radius: 10px;
      background: transparent;
    }
    button:hover {
      background: rgba(30, 102, 245, 0.15);
    }
    image {
      padding: 2px;
    }
  '';
}
