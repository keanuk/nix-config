{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nil
    nixd
    nixdoc
  ];
}
