{
  cat = "bat";
  cd = "z";
  cleanup = "nix-store --gc";
  find = "fd";
  fzf = "sk";
  grep = "rg";
  ll = "eza -l";
  ls = "eza";
  nano = "micro";
  optimize = "nix-store --optimize";
  rebuild = "sudo nixos-rebuild switch --upgrade --flake ~/.config/nix-config";
  rebuild-darwin = "sudo darwin-rebuild switch --flake ~/.config/nix-config";
  rebuild-offline = "sudo nixos-rebuild switch --option substitute false";
  repair = "sudo nix-store --verify --check-contents --repair";
  top = "btm";
  update = "nix flake update --flake ~/.config/nix-config";
  update-darwin = "nix flake update --flake /Users/keanu/.config/nix-config";
  vi = "hx";
  vim = "nvim";
}
