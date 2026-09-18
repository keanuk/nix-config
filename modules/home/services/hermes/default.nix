{ inputs, ... }:
{
  flake.modules.homeManager.hermes =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.hermesSecrets;

      imggen = pkgs.writeShellApplication {
        name = "imggen";
        runtimeInputs = with pkgs; [
          curl
          jq
          coreutils
          gnused
        ];
        text = builtins.readFile ./imggen.sh;
      };

      mkSkill = name: description: path: ''
        ---
        name: ${name}
        description: ${description}
        ---

        ${builtins.readFile path}
      '';

      secretsEnv = "${config.home.homeDirectory}/.config/hermes/secrets.env";
    in
    {
      imports = [
        inputs.hermes-agent.homeManagerModules.default
      ];

      options.programs.hermesSecrets = {
        telegramTokenFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Path to the Telegram bot token file for hermes.";
        };
        openaiApiKeyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Path to the OpenAI API key file for hermes.";
        };
        primaryModel = lib.mkOption {
          type = lib.types.str;
          default = "ollama/gemma4:latest";
          description = "Primary model for hermes (config.yaml model.default).";
        };
      };

      config = {
        home = {
          packages = [
            pkgs.unstable.ddgr
            imggen
          ];

          # Build the env file that services.hermes-agent.environmentFiles
          # points to. Runs before the hermes module's hermesAgentSetup
          # activation, which rewrites ~/.hermes/.env on every activation.
          activation.hermesAgentSecrets = lib.hm.dag.entryBefore [ "hermesAgentSetup" ] ''
            TELEGRAM_TOKEN=""
            OPENAI_KEY=""
            ${lib.optionalString (cfg.telegramTokenFile != null) ''
              if [ -f "${toString cfg.telegramTokenFile}" ]; then
                TELEGRAM_TOKEN="$(cat "${toString cfg.telegramTokenFile}" | tr -d "\n")"
              fi
            ''}
            ${lib.optionalString (cfg.openaiApiKeyFile != null) ''
              if [ -f "${toString cfg.openaiApiKeyFile}" ]; then
                OPENAI_KEY="$(cat "${toString cfg.openaiApiKeyFile}" | tr -d "\n")"
              fi
            ''}
            run mkdir -p "$(dirname "${secretsEnv}")"
            if [[ ! -v DRY_RUN ]]; then
              printf 'TELEGRAM_BOT_TOKEN=%s\nOPENAI_API_KEY=%s\n' \
                "$TELEGRAM_TOKEN" "$OPENAI_KEY" \
                > "${secretsEnv}"
              run chmod 600 "${secretsEnv}"
            fi
          '';
        };

        programs.hermes-agent.enable = true;

        services.hermes-agent = {
          enable = true;
          gateway.enable = true;

          workingDirectory = config.home.homeDirectory;

          settings = {
            model.default = cfg.primaryModel;
          };

          environment = {
            TELEGRAM_ALLOWED_USERS = "15634717";
          };

          environmentFiles = [ secretsEnv ];

          documents = {
            "AGENTS.md" = ./documents/AGENTS.md;
            "TOOLS.md" = ./documents/TOOLS.md;
          };

          hermesHomeFiles = {
            "SOUL.md" = ./documents/SOUL.md;
            "skills/web-browse/SKILL.md" =
              mkSkill "web-browse" "Search the web with DuckDuckGo and fetch page content."
                ./skills/web-browse.md;
            "skills/image-generation/SKILL.md" =
              mkSkill "image-generation"
                "Generate images from text prompts using the imggen CLI (OpenAI Images API)."
                ./skills/image-generation.md;
          };
        };
      };
    };
}
