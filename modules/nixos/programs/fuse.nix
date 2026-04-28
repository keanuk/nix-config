{
  flake.modules.nixos.prog-fuse = {
    programs.fuse = {
      enable = true;
    };
  };
}
