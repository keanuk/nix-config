{ pkgs, ... }:

{
  home.packages = with pkgs; [
    angular-language-server
    nodejs
    htmx-lsp2
    svelte-language-server
    tailwindcss-language-server
    typescript
    typescript-language-server

    nodePackages_latest.svelte-check
  ];
}
