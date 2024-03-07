{ pkgs, ... }:

{
  users.users.keanu.packages = with pkgs; [
    nodePackages.nodejs
    nodePackages."@angular/cli"
    nodePackages.typescript
    nodePackages.typescript-language-server
  ];
}
