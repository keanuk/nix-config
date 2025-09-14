{pkgs, ...}: {
  home.packages = with pkgs; [
    angular-language-server
    bun
    deno
    eslint
    htmx-lsp2
    pnpm
    svelte-language-server
    tailwindcss_4
    tailwindcss-language-server
    typescript
    typescript-language-server

    nodePackages.nodejs
  ];
}
