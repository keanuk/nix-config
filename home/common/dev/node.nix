{pkgs, ...}: {
  home.packages = with pkgs; [
    angular-language-server
    autoprefixer
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
  ];
}
