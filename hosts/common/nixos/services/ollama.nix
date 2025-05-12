{
  pkgs,
  lib,
  config,
  ...
}: {
  # TODO: re-enable when the build succeeds
  # imports = [
  #   ./open-webui.nix
  # ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama;
    user = "ollama";
    group = "ollama";
    home = "/var/lib/ollama";
    port = 11434;
    openFirewall = false;
    loadModels = [
      "codestral"
      "deepseek-r1"
      "gemma3"
      "mistral"
      "mistral-small"
      "qwen3"
    ];
  };

  # Workaround for: https://github.com/NixOS/nixpkgs/issues/357604
  systemd.services.ollama.serviceConfig = let
    cfg = config.services.ollama;
    ollamaPackage = cfg.package.override {inherit (cfg) acceleration;};
  in
    lib.mkForce {
      Type = "exec";
      ExecStart = "${lib.getExe ollamaPackage} serve";
      WorkingDirectory = cfg.home;
      SupplementaryGroups = ["render"];
    };
}
