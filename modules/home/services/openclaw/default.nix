{ inputs, ... }:
{
  flake.modules.homeManager.openclaw =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.openclawSecrets;

      documentSources = ./documents;

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
    in
    {
      imports = [
        inputs.nix-openclaw.homeManagerModules.openclaw
      ];

      options.programs.openclawSecrets = {
        telegramTokenFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to the Telegram bot token file for openclaw.";
        };
        mistralApiKeyFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to the Mistral API key file for openclaw.";
        };
        gatewayTokenFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to the openclaw gateway token file.";
        };
        openaiApiKeyFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to the OpenAI API key file for openclaw.";
        };
        primaryModel = lib.mkOption {
          type = lib.types.str;
          default = "mistral/mistral-large-latest";
          description = "Primary model for openclaw agents.";
        };
        fallbackModels = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "mistral/mistral-medium-latest"
            "mistral/mistral-small-latest"
          ];
          description = "Fallback models for openclaw agents.";
        };
      };

      config = {
        home = {
          file.".openclaw/openclaw.json".force = true;

          packages = [
            pkgs.unstable.ddgr
            imggen
          ];

          activation = {
            # Seed workspace documents only when they don't already exist,
            # so openclaw can freely update them at runtime.
            openclawSeedDocuments = {
              after = [ "writeBoundary" ];
              before = [ "openclawAuthProfiles" ];
              data =
                let
                  dir = "$HOME/.openclaw/workspace";
                  seed = name: ''
                    if [ ! -f "${dir}/${name}" ]; then
                      run cp "${documentSources}/${name}" "${dir}/${name}"
                      chmod 644 "${dir}/${name}"
                    fi
                  '';
                in
                ''
                  run mkdir -p "${dir}"
                  ${seed "AGENTS.md"}
                  ${seed "SOUL.md"}
                  ${seed "TOOLS.md"}
                '';
            };

            # Write auth-profiles.json for Mistral and OpenAI provider auth.
            openclawAuthProfiles = {
              after = [ "writeBoundary" ];
              before = [ ];
              data = ''
                AUTH_DIR="$HOME/.openclaw/agents/main/agent"
                run mkdir -p "$AUTH_DIR"
                MISTRAL_KEY=""
                OPENAI_KEY=""
                if [ -f "${cfg.mistralApiKeyFile}" ]; then
                  MISTRAL_KEY="$(cat "${cfg.mistralApiKeyFile}" | tr -d "\n")"
                fi
                if [ -f "${cfg.openaiApiKeyFile}" ]; then
                  OPENAI_KEY="$(cat "${cfg.openaiApiKeyFile}" | tr -d "\n")"
                fi
                printf '%s\n' \
                  "{\"version\":1,\"profiles\":{\"mistral:default\":{\"type\":\"api_key\",\"provider\":\"mistral\",\"key\":\"$MISTRAL_KEY\"},\"openai:default\":{\"type\":\"api_key\",\"provider\":\"openai\",\"key\":\"$OPENAI_KEY\"},\"ollama:default\":{\"type\":\"api_key\",\"provider\":\"ollama\",\"key\":\"ollama-local\"}}}" \
                  > "$AUTH_DIR/auth-profiles.json"
                chmod 600 "$AUTH_DIR/auth-profiles.json"
              '';
            };

            # Write secrets.env for gateway environment injection.
            # Linux: loaded via systemd EnvironmentFile.
            # macOS: sourced by tools like imggen as a fallback.
            openclawSecrets = {
              after = [ "writeBoundary" ];
              before = [ ];
              data = ''
                OPENCLAW_ENV_DIR="$HOME/.config/openclaw"
                run mkdir -p "$OPENCLAW_ENV_DIR"
                GW_TOKEN=""
                MISTRAL_KEY=""
                OPENAI_KEY=""
                if [ -f "${cfg.gatewayTokenFile}" ]; then
                  GW_TOKEN="$(cat "${cfg.gatewayTokenFile}" | tr -d "\n")"
                fi
                if [ -f "${cfg.mistralApiKeyFile}" ]; then
                  MISTRAL_KEY="$(cat "${cfg.mistralApiKeyFile}" | tr -d "\n")"
                fi
                if [ -f "${cfg.openaiApiKeyFile}" ]; then
                  OPENAI_KEY="$(cat "${cfg.openaiApiKeyFile}" | tr -d "\n")"
                fi
                printf 'OPENCLAW_GATEWAY_TOKEN=%s\nMISTRAL_API_KEY=%s\nOPENAI_API_KEY=%s\n' \
                  "$GW_TOKEN" "$MISTRAL_KEY" "$OPENAI_KEY" \
                  > "$OPENCLAW_ENV_DIR/secrets.env"
                chmod 600 "$OPENCLAW_ENV_DIR/secrets.env"
              '';
            };
          };
        };

        programs.openclaw = {
          enable = true;

          bundledPlugins = {
            summarize.enable = true;
            peekaboo.enable = pkgs.stdenv.hostPlatform.isDarwin;
            poltergeist.enable = pkgs.stdenv.hostPlatform.isDarwin;
            goplaces.enable = false;
            bird.enable = false;
            imsg.enable = false;
          };

          excludeTools = [
            "bird"
            "curl"
            "ffmpeg"
            "go"
            "jq"
            "python3"
            "ripgrep"
          ];

          skills = [
            {
              name = "web-browse";
              description = "Search the web with DuckDuckGo and fetch page content.";
              mode = "inline";
              body = builtins.readFile ./skills/web-browse.md;
            }
            {
              name = "image-generation";
              description = "Generate images from text prompts using the OpenAI Images API (DALL-E / gpt-image-1).";
              mode = "inline";
              body = builtins.readFile ./skills/image-generation.md;
            }
          ];

          instances.default = {
            config = {
              gateway = {
                mode = "local";
                auth.token = "nix-managed-use-env-var";
              };

              agents.defaults.model = {
                primary = cfg.primaryModel;
                fallbacks = cfg.fallbackModels;
              };

              channels.telegram = {
                tokenFile = cfg.telegramTokenFile;
                allowFrom = [ 15634717 ];
                groups."*".requireMention = true;
              };
            };
          };
        };

        # Inject secrets.env on Linux via systemd EnvironmentFile.
        systemd.user.services.openclaw-gateway = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          Install.WantedBy = [ "default.target" ];
          Service.EnvironmentFile = [ "%h/.config/openclaw/secrets.env" ];
        };

        # Provide npm and node to the macOS gateway launchd service without colliding in home.packages.
        launchd.agents.openclaw-gateway = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          config.EnvironmentVariables.PATH = lib.mkDefault "${
            lib.makeBinPath [ pkgs.nodejs ]
          }:/run/current-system/sw/bin:/bin:/usr/bin:/sbin:/usr/sbin";
        };
      };
    };
}
