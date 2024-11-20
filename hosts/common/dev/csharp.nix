{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    dotnet-sdk_8
    mono
  ];
}
