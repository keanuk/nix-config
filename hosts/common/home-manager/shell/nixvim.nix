{ pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    enableMan = true;
    defaultEditor = false;
    viAlias = true;
    vimAlias = true;

    options = {
      autochdir = true;

      autoindent = true;
      cindent = true;
      smartindent = true;

      expandtab = true;
      shiftwidth = 2;
      smarttab = true;
      softtabstop = 2;
      tabstop = 2;

      hlsearch = true;
      ignorecase = true;
      showmatch = true;
      
      number = true;
      relativenumber = false;
      termguicolors = true;
    };
    
    plugins.lightline.enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      bufferline-nvim
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      telescope-nvim
      vim-nix
    ];

    colorschemes.gruvbox.enable = true;
  };
}
