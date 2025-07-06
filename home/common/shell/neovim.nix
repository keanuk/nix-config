{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    defaultEditor = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      vim.opt.autochdir = true

      vim.opt.autoindent = true
      vim.opt.cindent = true
      vim.opt.smartindent = true

      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.smarttab = true
      vim.opt.softtabstop = 2
      vim.opt.tabstop = 2

      vim.opt.hlsearch = true
      vim.opt.ignorecase = true
      vim.opt.showmatch = true

      vim.opt.number = true
      vim.opt.termguicolors = true
    '';

    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      telescope-nvim
      vim-nix
    ];
  };
}
