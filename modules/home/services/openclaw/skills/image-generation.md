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
| `--model` | `gpt-image-1`, `gpt-image-1.5`, `gpt-image-1-mini` | `gpt-image-1` | Model to use |
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

The `OPENAI_API_KEY` is loaded automatically from
`~/.config/openclaw/secrets.env` if not already in the environment.
Images are saved to `/tmp/openclaw/imggen/` by default.

## Error handling

- If the API returns an error about content policy, let the user know
  their prompt was flagged and suggest modifications.
- If `OPENAI_API_KEY` is not set, tell the user the image generation
  service needs to be configured with an OpenAI API key.