{ config, ... }:

{
  services.nextcloud = {
    enable = true;
    hostName = builtins.getEnv "HOST";
  };
}
