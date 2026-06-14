{ pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    settings = {
      general = {
        grace = 0;
        no_fade_in = false;
        disable_loading_bar = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.02;
          contrast = 0.9;
          brightness = 0.8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(cdd6f4)";
          inner_color = "rgb(1e1e2e)";
          outer_color = "rgb(313244)";
          check_color = "rgb(89b4fa)";
          fail_color = "rgb(f38ba8)";
          outline_thickness = 2;
          placeholder_text = ''<span foreground="#cdd6f4">Password...</span>'';
          shadow_passes = 2;
        }
      ];

      label = [
        {
          text = "$TIME";
          position = "0, 80";
          font_size = 64;
          font_family = "RobotoMono Nerd Font";
          color = "rgb(cdd6f4)";
          shadow_passes = 2;
        }
        {
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          position = "0, 30";
          font_size = 18;
          font_family = "Roboto";
          color = "rgb(cdd6f4)";
          shadow_passes = 2;
        }
      ];
    };
  };
}
