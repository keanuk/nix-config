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