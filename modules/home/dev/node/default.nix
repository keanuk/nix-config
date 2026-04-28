{ config, ... }:
{
  flake.modules.homeManager.node =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        angular-language-server
        bun
        deno
        eslint
        htmx-lsp2
        (lib.hiPrio nodejs)
        (lib.hiPrio pnpm)
        svelte-check
        svelte-language-server
        tailwindcss_4
        tailwindcss-language-server
        typescript
        typescript-language-server
      ];
    };

  flake.modules.homeManager.dev = config.flake.modules.homeManager.node;
}
