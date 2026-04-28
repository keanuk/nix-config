import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Show git commit history for a file or path. Useful for understanding what changed, when, and by whom.",
  args: {
    path: tool.schema
      .string()
      .optional()
      .describe(
        "File or directory path to show history for, relative to project root. Omit for full repo history.",
      ),
    count: tool.schema
      .number()
      .optional()
      .describe("Number of commits to show (default: 10)"),
    author: tool.schema
      .string()
      .optional()
      .describe("Filter by author name or email"),
    since: tool.schema
      .string()
      .optional()
      .describe("Show commits since date (e.g. '2 weeks ago', '2024-01-01')"),
  },
  async execute(args, context) {
    const count = args.count ?? 10

    const gitArgs = [
      "log",
      `--max-count=${count}`,
      "--format=%h %an %ad %s",
      "--date=short",
    ]

    if (args.author) {
      gitArgs.push(`--author=${args.author}`)
    }
    if (args.since) {
      gitArgs.push(`--since=${args.since}`)
    }
    if (args.path) {
      gitArgs.push("--", args.path)
    }

    const proc = await new Bun.Command("git", gitArgs, {
      cwd: context.worktree,
    })

    if (!proc.success) {
      return `Error: ${proc.stderr.toString().trim()}`
    }

    const output = proc.stdout.toString().trim()
    if (!output) {
      return "No commits found matching the criteria."
    }

    return output
  },
})