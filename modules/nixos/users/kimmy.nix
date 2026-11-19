{
  flake.modules.nixos.kimmy =
    {
      pkgs,
      config,
      ...
    }:
    {
      sops.secrets.user-kimmy-password = {
        neededForUsers = true;
      };

      users.users.kimmy = {
        isNormalUser = true;
        uid = 1001;
        home = "/home/kimmy";
        description = "Kimmy Bucaccio";
        extraGroups = [
          "networkmanager"
        ];
        shell = pkgs.fish;
        hashedPasswordFile = config.sops.secrets.user-kimmy-password.path;
      };
    };
}
