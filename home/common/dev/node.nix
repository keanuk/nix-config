{pkgs, ...}: {
  home.packages = with pkgs; [
    angular-language-server
    autoprefixer
    htmx-lsp2
    svelte-language-server
    tailwindcss_4
    tailwindcss-language-server
    typescript
    typescript-language-server

    nodePackages_latest.nodejs
    # TODO: enable when the build succeeds
    # nodePackages_latest.postcss
    nodePackages_latest.svelte-check
  ];
}
