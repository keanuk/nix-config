{
  flake.modules.nixos.user-keanu-data-groups = {
    users = {
      groups.data = {
        gid = 554;
      };

      groups.media = {
        gid = 555;
      };

      users.keanu.extraGroups = [
        "data"
        "media"
      ];
    };
  };
}
