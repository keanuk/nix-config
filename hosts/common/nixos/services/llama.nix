{ pkgs, ... }:

{
  imports = [
    ./open-webui.nix
  ];

  services.llama-cpp = {
      enable = true;
      package = pkgs.llama-cpp;
  };
}
