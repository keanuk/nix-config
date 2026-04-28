import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Show git blame for a file, indicating who changed each line and when. Useful for understanding the history and ownership of code.",
  args: {
    file: tool.schema
      .string()
      .describe("Path to the file to blame, relative to the project root"),
    start: tool.schema
      .number()
      .optional()
      .describe("Start line number (1-based)"),
    end: tool.schema
      .number()
      .optional()
      .describe("End line number (1-based, inclusive)"),
  },
  async execute(args, context) {
    const range =
      args.start && args.end ? `-L ${args.start},${args.end}` : ""
    const cmd = new Bun.Command("git", [
      "blame",
      "--porcelain",
      ...([range, args.file].filter(Boolean) as string[]),
    ], {
      cwd: context.worktree,
    })
    const proc = await cmd
    if (!proc.success) {
      return `Error running git blame: ${proc.stderr.toString().trim()}`
    }
    const output = proc.stdout.toString().trim()

    const porcelainProc = await new Bun.Command("git", [
      "blame",
      "--line-porcelain",
      ...(range ? ["-L", `${args.start},${args.end}`] : []),
      args.file,
    ], {
      cwd: context.worktree,
    }).safe()

    if (!porcelainProc.success) {
      return `Error: ${porcelainProc.stderr.toString().trim()}`
    }

    const lines = porcelainProc.stdout.toString().trim().split("\n")
    const results: string[] = []

    let currentCommit: string | null = null
    let currentAuthor: string | null = null
    let currentTime: string | null = null
    let currentSummary: string | null = null

    for (const line of lines) {
      if (line.startsWith("author ")) {
        currentAuthor = line.slice(7)
      } else if (line.startsWith("author-time ")) {
        const ts = parseInt(line.slice(12))
        currentTime = new Date(ts * 1000).toISOString().split("T")[0]
      } else if (line.startsWith("summary ")) {
        currentSummary = line.slice(8)
      } else if (line.startsWith("\t")) {
        const code = line.slice(1)
        const shortHash = (currentCommit || "unknown").slice(0, 7)
        results.push(
          `${shortHash} ${currentAuthor} ${currentTime} | ${currentSummary?.slice(0, 60)}\n  ${code}`,
        )
        currentCommit = null
        currentAuthor = null
        currentTime = null
        currentSummary = null
      } else if (
        line.length >= 40 &&
        /^[0-9a-f]{40}/.test(line.slice(0, 40))
      ) {
        currentCommit = line.slice(0, 40)
      }
    }

    return results.join("\n\n")
  },
})