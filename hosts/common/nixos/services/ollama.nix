{
  pkgs,
  lib,
  config,
  ...
}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama;
    port = 11434;
    openFirewall = false;
    user = "ollama";
    group = "ollama";
    home = "/var/lib/ollama";
    loadModels = [
      "codestral"
      "deepseek-r1"
      "devstral"
      "gemma3"
      "mistral"
      "mistral-small"
      "qwen2.5-coder"
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
