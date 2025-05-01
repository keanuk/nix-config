{ pkgs, ... }: {
  services.desktopManager = {
    cosmic = {
      enable = true;
      xwayland.enable = true;
    };
    cosmic-greeter.enable = true;
  };

  environment.systemPackages = with pkgs; [
    tasks
  ];
}
