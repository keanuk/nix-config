# OpenClaw AI assistant gateway configuration
#
# This mixin configures nix-openclaw with Telegram + Mistral AI,
# plus web browsing (ddgr + curl) and image generation (imggen + OpenAI).
#
# Each host must pass the secret file paths via module arguments.
#
# Secret paths come from sops-nix on both platforms:
#   - NixOS (beehive): NixOS sops module → /run/secrets/
#   - macOS (salacia): Home Manager sops module → ~/.config/sops-nix/secrets/
#
# Usage in host config:
#   (import ../_mixins/services/openclaw {
#     inherit inputs;
#     openclawTelegramTokenFile = "/run/secrets/...";
#     openclawMistralApiKeyFile = "/run/secrets/...";
#     openclawGatewayTokenFile  = "/run/secrets/...";
#     openclawOpenaiApiKeyFile  = "/run/secrets/...";
#   })
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
  # Document sources used to seed the workspace on first run.
  # These are NOT passed to programs.openclaw.documents — openclaw owns
  # these files at runtime so it can update SOUL.md, AGENTS.md, and
  # TOOLS.md itself (e.g. recording discoveries in TOOLS.md).
  documentSources = ./documents;
in
{
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  home.file.".openclaw/openclaw.json".force = true;

  # ---------------------------------------------------------------------------
  # Extra packages required by inline skills
  # ---------------------------------------------------------------------------
  home.packages = [
    pkgs.unstable.ddgr # DuckDuckGo web search from the terminal
    pkgs.openclaw-imggen # Image generation CLI (OpenAI DALL-E wrapper)
  ];

  programs.openclaw = {
    enable = true;

    # NOTE: We intentionally do NOT set `documents` here.
    # Setting it causes Nix to manage AGENTS.md, SOUL.md, and TOOLS.md as
    # read-only symlinks into the Nix store, which prevents openclaw from
    # writing back to them at runtime. Instead we seed these files via
    # home.activation (below) only when they don't already exist.

    bundledPlugins = {
      summarize.enable = true;
      peekaboo.enable = pkgs.stdenv.hostPlatform.isDarwin;
      poltergeist.enable = pkgs.stdenv.hostPlatform.isDarwin;
      goplaces.enable = false;
      bird.enable = false;
      imsg.enable = false;
    };

    # The steipete/bird GitHub repo and its releases have been deleted,
    # so the bird package fails to fetch. Exclude it until upstream fixes this.
    # Also exclude tools that conflict with individually installed packages
    # (python3, idle, node, go, rg, ffmpeg, curl, jq, etc.) to avoid
    # buildEnv collisions in home-manager-path.
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

    # -------------------------------------------------------------------------
    # Inline skills — web browsing & image generation
    # -------------------------------------------------------------------------
    skills = [
      # -- Web Search & Browsing -----------------------------------------------
      {
        name = "web-browse";
        description = "Search the web with DuckDuckGo and fetch page content.";
        mode = "inline";
        body = ''
          # Web Browse

          Search the web and fetch page content using CLI tools.

          ## When to use (trigger phrases)

          Use this skill when the user asks any of:
          - "search for …" / "look up …" / "google …"
          - "what is …" / "who is …" (when you don't know the answer)
          - "find me …" / "search the web for …"
          - "what's the latest on …" / "any news about …"
          - Any question where your training data may be outdated

          ## Tools

          ### `ddgr` — DuckDuckGo search

          ```bash
          # Basic search (returns titles, URLs, and snippets)
          ddgr --np --np -n 5 "search query here"

          # News search
          ddgr --np -n 5 --news "topic"

          # Search a specific site
          ddgr --np -n 5 "site:example.com query"

          # JSON output (machine-readable, easier to parse)
          ddgr --np -n 5 --json "search query"
          ```

          Key flags:
          - `--np` : non-interactive (no prompt, just print results)
          - `-n N` : number of results (default 5, max ~25)
          - `--json` : output as JSON array
          - `--news` : search news instead of web
          - `-w SITE` : search only within a specific site
          - `--noprompt` : alias for `--np`

          ### `curl` — Fetch page content

          After finding a URL from search results, fetch its content:

          ```bash
          # Fetch a page (follow redirects, silent mode)
          curl -sL "https://example.com/page" | head -500

          # Fetch with a browser-like user agent (some sites block curl)
          curl -sL -A "Mozilla/5.0" "https://example.com/page" | head -500

          # Fetch just the headers to check content type/size
          curl -sI "https://example.com/page"
          ```

          ### Combining search + fetch

          Typical workflow:
          1. Search with `ddgr --np --json -n 5 "query"`
          2. Pick the most relevant URL(s)
          3. Fetch content with `curl -sL "URL" | head -500`
          4. Summarize or extract the relevant information

          For richer page extraction (HTML → clean text, PDFs, YouTube),
          prefer the **summarize** skill instead of raw curl when available.

          ## Tips

          - Start with 5 results; increase if nothing relevant comes up.
          - Use `--json` when you need to programmatically pick URLs.
          - Pipe curl output through `head` to avoid dumping huge pages.
          - If a site blocks curl, try adding a user-agent header.
          - For deep reading of a single URL, hand off to `summarize` if enabled.
          - Always cite your sources — include the URL when sharing info from the web.
        '';
      }

      # -- Image Generation ----------------------------------------------------
      {
        name = "image-generation";
        description = "Generate images from text prompts using the OpenAI Images API (DALL-E / gpt-image-1).";
        mode = "inline";
        body = ''
          # Image Generation

          Generate images from text descriptions using the `imggen` CLI.

          ## When to use (trigger phrases)

          Use this skill when the user asks any of:
          - "generate an image of …" / "create an image …"
          - "draw …" / "make a picture of …"
          - "imagine …" / "visualize …"
          - "create art of …" / "design …"
          - Any request that implies creating a visual from a description

          ## Tool: `imggen`

          ```bash
          # Basic usage — generates a 1024x1024 image
          imggen "a cat wearing a top hat, oil painting style"

          # Landscape image (wider)
          imggen --size 1536x1024 "a panoramic sunset over mountains"

          # Portrait image (taller)
          imggen --size 1024x1536 "a tall lighthouse on a cliff"

          # High quality
          imggen --quality high "detailed botanical illustration of a rose"

          # Specify output path
          imggen --output /tmp/my-image.png "abstract watercolor art"

          # Combine flags
          imggen --size 1536x1024 --quality high "a cozy cabin in a snowy forest, digital art"
          ```

          ## Options

          | Flag | Values | Default | Description |
          |------|--------|---------|-------------|
          | `--size` | `1024x1024`, `1536x1024`, `1024x1536`, `auto` | `1024x1024` | Image dimensions |
          | `--quality` | `low`, `medium`, `high`, `auto` | `auto` | Generation quality |
          | `--model` | `gpt-image-1` | `gpt-image-1` | Model to use |
          | `--output` | file path | auto-generated | Where to save the image |
          | `--output-dir` | directory path | `/tmp/openclaw/imggen` | Directory for auto-named images |

          ## Output

          `imggen` prints the path to the saved PNG file on the last line of stdout.
          **Always send this file back to the user** so they can see the result.

          ## Sending the image

          After generating, the image is saved as a PNG file. Send it back to the
          user in the chat. The file path is printed by imggen — use it directly.

          ## Prompt tips

          - Be descriptive: include style, mood, colors, composition.
          - Mention art styles: "oil painting", "watercolor", "digital art",
            "pixel art", "photorealistic", "anime style", etc.
          - Include context: "on a white background", "at sunset", "in a forest".
          - For people/characters: describe pose, expression, clothing.
          - Keep prompts under ~500 characters for best results.

          ## Environment

          Requires `OPENAI_API_KEY` to be set (handled by secrets.env automatically).
          Images are saved to `/tmp/openclaw/imggen/` by default.

          ## Error handling

          - If the API returns an error about content policy, let the user know
            their prompt was flagged and suggest modifications.
          - If `OPENAI_API_KEY` is not set, tell the user the image generation
            service needs to be configured with an OpenAI API key.
        '';
      }
    ];

    instances.default = {
      config = {
        gateway = {
          mode = "local";
          auth = {
            # Placeholder — overridden at runtime by OPENCLAW_GATEWAY_TOKEN
            # env var loaded from secrets.env.
            token = "nix-managed-use-env-var";
          };
        };

        agents = {
          defaults = {
            model = {
              primary = "mistral/mistral-large-latest";
              fallbacks = [
                "mistral/mistral-medium-latest"
                "mistral/mistral-small-latest"
              ];
            };
          };
        };

        channels.telegram = {
          tokenFile = openclawTelegramTokenFile;
          allowFrom = [ 15634717 ];
          groups = {
            "*" = {
              requireMention = true;
            };
          };
        };
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Activation scripts
  # ---------------------------------------------------------------------------

  # Seed workspace documents (AGENTS.md, SOUL.md, TOOLS.md) on first run.
  # If the files already exist they are left untouched so openclaw can freely
  # update them at runtime.
  home.activation.openclawSeedDocuments = {
    after = [ "writeBoundary" ];
    before = [ "openclawAuthProfiles" ];
    data =
      let
        workspaceDir = "$HOME/.openclaw/workspace";
        seedFile = name: ''
          if [ ! -f "${workspaceDir}/${name}" ]; then
            run cp "${documentSources}/${name}" "${workspaceDir}/${name}"
            chmod 644 "${workspaceDir}/${name}"
            echo "openclaw: seeded ${name}"
          fi
        '';
      in
      ''
        run mkdir -p "${workspaceDir}"
        ${seedFile "AGENTS.md"}
        ${seedFile "SOUL.md"}
        ${seedFile "TOOLS.md"}
      '';
  };

  # Write auth-profiles.json so the gateway can authenticate with Mistral.
  home.activation.openclawAuthProfiles = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      AUTH_DIR="$HOME/.openclaw/agents/main/agent"
      run mkdir -p "$AUTH_DIR"
      MISTRAL_KEY=""
      if [ -f "${openclawMistralApiKeyFile}" ]; then
        MISTRAL_KEY="$(cat "${openclawMistralApiKeyFile}" | tr -d "\n")"
      fi
      printf '%s\n' \
        "{\"version\":1,\"profiles\":{\"mistral:default\":{\"type\":\"api_key\",\"provider\":\"mistral\",\"key\":\"$MISTRAL_KEY\"}}}" \
        > "$AUTH_DIR/auth-profiles.json"
      chmod 600 "$AUTH_DIR/auth-profiles.json"
    '';
  };

  # Write a secrets.env file that injects secrets into the gateway's
  # environment at runtime. The gateway reads OPENCLAW_GATEWAY_TOKEN,
  # MISTRAL_API_KEY, and OPENAI_API_KEY from its process environment.
  home.activation.openclawSecrets = {
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
}
