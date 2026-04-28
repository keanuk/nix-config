# Defaults
MODEL="${IMGGEN_MODEL:-gpt-image-1}"
SIZE="${IMGGEN_SIZE:-1024x1024}"
QUALITY="${IMGGEN_QUALITY:-auto}"
OUTPUT_DIR="${IMGGEN_OUTPUT_DIR:-/tmp/openclaw/imggen}"
OUTPUT=""
PROMPT=""

usage() {
  cat <<EOF
Usage: imggen [OPTIONS] "PROMPT"

Generate an image from a text prompt using the OpenAI Images API.

Options:
  --model MODEL     Model to use (default: gpt-image-1)
  --size SIZE       Image size: 1024x1024, 1536x1024, 1024x1536, auto (default: 1024x1024)
  --quality QUAL    Quality: low, medium, high, auto (default: auto)
  --output PATH     Output file path (default: auto-generated in \$OUTPUT_DIR)
  --output-dir DIR  Output directory (default: /tmp/openclaw/imggen)
  -h, --help        Show this help message

Environment:
  OPENAI_API_KEY    Required. Your OpenAI API key.

Examples:
  imggen "a cat wearing a top hat"
  imggen --size 1536x1024 --quality high "a sunset over mountains"
  imggen --output /tmp/art.png "abstract art in watercolor"
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --model)     MODEL="$2";      shift 2 ;;
    --size)      SIZE="$2";       shift 2 ;;
    --quality)   QUALITY="$2";    shift 2 ;;
    --output)    OUTPUT="$2";     shift 2 ;;
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    -h|--help)   usage ;;
    -*)
      echo "Error: unknown option '$1'" >&2
      echo "Run 'imggen --help' for usage." >&2
      exit 1
      ;;
    *)
      if [[ -n "$PROMPT" ]]; then
        echo "Error: multiple prompts given. Wrap your prompt in quotes." >&2
        exit 1
      fi
      PROMPT="$1"
      shift
      ;;
  esac
done

if [[ -z "$PROMPT" ]]; then
  echo "Error: no prompt provided." >&2
  echo "Run 'imggen --help' for usage." >&2
  exit 1
fi

# Source secrets.env as fallback (e.g. macOS launchd doesn't inherit env).
if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  SECRETS_ENV="${HOME}/.config/openclaw/secrets.env"
  if [[ -f "$SECRETS_ENV" ]]; then
    set -a
    # shellcheck disable=SC1090
    . "$SECRETS_ENV"
    set +a
  fi
fi

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  echo "Error: OPENAI_API_KEY is not set." >&2
  echo "Set it, or ensure ~/.config/openclaw/secrets.env contains it." >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

if [[ -z "$OUTPUT" ]]; then
  TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
  SLUG="$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | cut -c1-40 | sed 's/-*$//')"
  OUTPUT="${OUTPUT_DIR}/${TIMESTAMP}-${SLUG}.png"
fi

JSON_PROMPT="$(printf '%s' "$PROMPT" | jq -Rs .)"

echo "Generating image..." >&2
echo "  Model:   $MODEL" >&2
echo "  Size:    $SIZE" >&2
echo "  Quality: $QUALITY" >&2
echo "  Prompt:  $PROMPT" >&2

RESPONSE="$(curl -s -w "\n%{http_code}" \
  "https://api.openai.com/v1/images/generations" \
  -H "Authorization: Bearer ${OPENAI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"${MODEL}\",
    \"prompt\": ${JSON_PROMPT},
    \"size\": \"${SIZE}\",
    \"quality\": \"${QUALITY}\"
  }")"

HTTP_CODE="$(echo "$RESPONSE" | tail -n1)"
BODY="$(echo "$RESPONSE" | sed '$d')"

if [[ "$HTTP_CODE" -ne 200 ]]; then
  ERROR_MSG="$(echo "$BODY" | jq -r '.error.message // "Unknown error"' 2>/dev/null || echo "Unknown error")"
  echo "Error: API returned HTTP $HTTP_CODE" >&2
  echo "  $ERROR_MSG" >&2
  exit 1
fi

B64_DATA="$(echo "$BODY" | jq -r '.data[0].b64_json // empty')"
if [[ -z "$B64_DATA" ]]; then
  echo "Error: no image data in response." >&2
  echo "Response: $BODY" >&2
  exit 1
fi

echo "$B64_DATA" | base64 -d > "$OUTPUT"

echo "Image saved to: $OUTPUT"
echo "$OUTPUT"
