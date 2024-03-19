{ pkgs, inputs, ... }:

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

    clipboard.providers.wl-copy.enable = true;

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

      #background = "light";
      number = true;
      relativenumber = false;
      termguicolors = true;
    };

    plugins = {
      bufferline.enable = true;
      lightline.enable = true;
      nix.enable = true;
      nix-develop.enable = true;
      nvim-autopairs.enable = true;
      cmp.enable = true;
      nvim-colorizer.enable = true;
      nvim-tree.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-web-devicons
    ];

    #colorschemes.gruvbox.enable = true;
  };
}
