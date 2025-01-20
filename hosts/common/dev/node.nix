{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.nodePackages_latest; [
    nodejs
    svelte-check
    svelte-language-server
    typescript
    typescript-language-server
  ];
}
