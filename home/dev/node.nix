{ pkgs, ... }:

{
  home.packages = with pkgs.nodePackages_latest; [
    nodejs
    svelte-check
    svelte-language-server
    typescript
    typescript-language-server
  ];
}
