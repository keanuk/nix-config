{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nim
    nimlangserver
  ];
}
