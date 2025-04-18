{ pkgs, ... }:

{
  users.users.keanu = {
    name = "keanu";
    home = "/Users/keanu";
    description = "Keanu Kerr";
    shell = pkgs.fish;
  };
}
