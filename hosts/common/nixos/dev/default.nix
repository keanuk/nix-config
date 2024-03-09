{ pkgs, ... }:

{
  imports = [
    ./c.nix
    ./go.nix
    ./lua.nix
    ./markup.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
  ];

  environment.systemPackages = with pkgs; [
    gcc
  ];
  
  users.users.keanu.packages = with pkgs; [
    dockerfile-language-server-nodejs
    nodePackages_latest.bash-language-server
  ];
}
