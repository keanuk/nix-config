{
  pkgs ? import <nixpkgs> { },
  inputs,
  ...
}:
let
  mkDevenv =
    modules:
    inputs.devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = modules ++ [ { devenv.root = toString ./.; } ];
    };
in
{
  default = mkDevenv [
    {
      packages = with pkgs; [
        nix
        home-manager
        git
        nix-output-monitor

        sops
        ssh-to-age
        gnupg
        age
      ];
    }
  ];
  c = mkDevenv [
    {
      packages = with pkgs; [
        clang-tools
        cmake
        cmake-language-server
        lldb
      ];
      languages.c.enable = true;
      languages.cplusplus.enable = true;
    }
  ];
  go = mkDevenv [
    {
      packages = with pkgs; [
        delve
        gopls
      ];
      languages.go.enable = true;
    }
  ];
  haskell = mkDevenv [
    {
      packages = with pkgs; [
      ];
      languages.haskell.enable = true;
      languages.haskell.stack.enable = true;
    }
  ];
  java = mkDevenv [
    {
      packages = with pkgs; [
        jdt-language-server
        kotlin
        kotlin-language-server
      ];
      languages.java.enable = true;
      languages.kotlin.enable = true;
    }
  ];
  lua = mkDevenv [
    {
      packages = with pkgs; [
        lua-language-server
      ];
      languages.lua.enable = true;
    }
  ];
  markup = mkDevenv [
    {
      packages = with pkgs; [
        marksman
        taplo
        yaml-language-server
      ];
    }
  ];
  nim = mkDevenv [
    {
      packages = with pkgs; [
        nimlangserver
      ];
      languages.nim.enable = true;
    }
  ];
  node = mkDevenv [
    {
      packages = with pkgs; [
        angular-language-server
        bun
        eslint
        htmx-lsp2
        pnpm
        svelte-language-server
        tailwindcss_4
        tailwindcss-language-server
        typescript-language-server
        nodePackages_latest.svelte-check
      ];
      languages = {
        javascript = {
          enable = true;
          npm.enable = true;
        };
        typescript.enable = true;
        deno.enable = true;
      };
    }
  ];
  python = mkDevenv [
    {
      packages = with pkgs; [
        python313Packages.python-lsp-server
      ];
      languages.python.enable = true;
    }
  ];
  rust = mkDevenv [
    {
      packages = with pkgs; [
        cargo-generate
        cargo-readme
        cargo-tauri
        crate2nix
        rust-analyzer
      ];
      languages.rust.enable = true;
    }
  ];
  zig = mkDevenv [
    {
      packages = with pkgs; [
        zls
      ];
      languages.zig.enable = true;
    }
  ];
}
