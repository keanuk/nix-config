{ lib, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = lib.mkDefault "base16";
    };
  };
}
