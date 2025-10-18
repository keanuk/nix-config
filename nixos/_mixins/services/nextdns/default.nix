{
  secrets,
  pkgs,
  ...
}: {
  nextdns = {
    enable = true;
    arguments = ["-config" "${secrets.nextdns.id}"];
  };

  environment.systemPackages = with pkgs; [
    nextdns
  ];
}
