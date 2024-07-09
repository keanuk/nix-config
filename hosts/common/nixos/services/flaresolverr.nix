{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.nur.nixosModules.nur
  ];

  systemd.services.flaresolverr = {
    enable = true;
    serviceConfig = {
      ExecStart = "${config.nur.repos.xddxdd.flaresolverr}/bin/flaresolverr";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
