{
  inputs,
  openclawTelegramTokenFile,
  openclawMistralApiKeyFile,
  openclawGatewayTokenFile,
  openclawOpenaiApiKeyFile,
  ...
}:
{
  pkgs,
  lib,
  ...
}:
let
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
          if [ -f "${openclawMistralApiKeyFile}" ]; then
            MISTRAL_KEY="$(cat "${openclawMistralApiKeyFile}" | tr -d "\n")"
          fi
          if [ -f "${openclawOpenaiApiKeyFile}" ]; then
            OPENAI_KEY="$(cat "${openclawOpenaiApiKeyFile}" | tr -d "\n")"
          fi
          printf '%s\n' \
            "{\"version\":1,\"profiles\":{\"mistral:default\":{\"type\":\"api_key\",\"provider\":\"mistral\",\"key\":\"$MISTRAL_KEY\"},\"openai:default\":{\"type\":\"api_key\",\"provider\":\"openai\",\"key\":\"$OPENAI_KEY\"}}}" \
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
          if [ -f "${openclawGatewayTokenFile}" ]; then
            GW_TOKEN="$(cat "${openclawGatewayTokenFile}" | tr -d "\n")"
          fi
          if [ -f "${openclawMistralApiKeyFile}" ]; then
            MISTRAL_KEY="$(cat "${openclawMistralApiKeyFile}" | tr -d "\n")"
          fi
          if [ -f "${openclawOpenaiApiKeyFile}" ]; then
            OPENAI_KEY="$(cat "${openclawOpenaiApiKeyFile}" | tr -d "\n")"
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
      "nodejs_22"
      "pnpm_10"
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
          primary = "mistral/mistral-large-latest";
          fallbacks = [
            "mistral/mistral-medium-latest"
            "mistral/mistral-small-latest"
          ];
        };

        channels.telegram = {
          tokenFile = openclawTelegramTokenFile;
          allowFrom = [ 15634717 ];
          groups."*".requireMention = true;
        };
      };
    };
  };

  # Inject secrets.env on Linux via systemd EnvironmentFile.
  systemd.user.services.openclaw-gateway = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    Service.EnvironmentFile = [ "%h/.config/openclaw/secrets.env" ];
  };
}
