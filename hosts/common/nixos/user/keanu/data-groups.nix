{ ... }:

{
  users.groups.data = {
    gid = 554;
  };

  users.groups.media = {
    gid = 555;
  };

  users.users.keanu.extraGroups = [
    "data"
    "media"
  ];
}
