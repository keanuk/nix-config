{ pkgs, ... }:
{
  users.users.keanu = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/keanu";
    description = "Keanu Kerr";
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
      "docker"
      "ollama"
    ];
    shell = pkgs.fish;
    initialPassword = "keanu";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICP+F1NN7ilYQdrDouylmVIJK3szsurUSl/ZtTWB2rE keanu@beehive"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILLEUWoP0i8HXYazjxNslNw0LBHemER7XTZOEhZIoVuC keanu@mars"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILUTr3M6BDAKYKmiFK0azvcJqTMdkxGqmFDYtwg7tFkt keanu@mars-wsl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOYuGM8TymDA4CwoFJUo2jJv0kVFYxEBOHmCuTgGcwaa keanu@phoebe"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWMzYrXSIYdnLCK+Tvg37gZtKhRimeo/0KuGc39jWen keanu@salacia"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFMejX8oSoN9Jp4HQcyGj9PZoLz30w3hty2lw6vWv5ab keanu@titan"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERTrzal23ssMxWgUfDJxeWYfwAbRcJ6zDeDNKsQu9Ag keanu@vesta"

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDS5rawgaqa78S0s07aGlWgvHrVzb3QzUocqq51u0od3 github-action-bucaccio"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0XU5XdS3NQxo6m8CkJHWKLGE8Dc0WgBi1hmfy4hqnI github-action-emilyvansant"
    ];
  };
}
