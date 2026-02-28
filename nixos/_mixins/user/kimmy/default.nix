{ pkgs, ... }:
{
  users.users.kimmy = {
    isNormalUser = true;
    uid = 1001;
    home = "/home/kimmy";
    description = "Kimmy Bucaccio";
    extraGroups = [
      "networkmanager"
    ];
    shell = pkgs.fish;
    # TODO: Replace initialPassword with a sops-managed hashed password.
    # This plaintext password is stored in the nix store and world-readable.
    # Use instead:
    #   hashedPasswordFile = config.sops.secrets.kimmy-password-hash.path;
    # where the secret contains the output of `mkpasswd -m sha-512`.
    initialPassword = "kimmy";
  };
}
