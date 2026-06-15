{
  flake.modules.homeManager.noctalia =
    {
      pkgs,
      inputs,
      lib,
      ...
    }:
    {
      programs.noctalia = {
        enable = true;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        systemd.enable = lib.mkDefault true;
        settings = {
          theme = {
            mode = "auto";
            source = "builtin";
            builtin = "Catppuccin";
          };
          location = {
            auto_locate = true;
          };
          dock = {
            enabled = true;
            position = "bottom";
            pinned = [
              "firefox"
              "Alacritty"
              "org.gnome.Nautilus"
              "discord"
            ];
          };
          bar.default = {
            start = [ "workspaces" ];
            center = [ "clock" ];
            end = [
              "network"
              "bluetooth"
              "volume"
              "battery"
              "notifications"
              "control-center"
              "session"
            ];
          };
          shell = {
            launch_apps_as_systemd_services = true;
            polkit_agent = true;
          };
        };
      };
    };
}
