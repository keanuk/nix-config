import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Show git diff — working tree changes, staged changes, or differences between refs. Essential for understanding what has changed before reviewing or committing.",
  args: {
    staged: tool.schema
      .boolean()
      .optional()
      .describe("Show only staged changes"),
    file: tool.schema
      .string()
      .optional()
      .describe("Limit diff to a specific file path"),
    from: tool.schema
      .string()
      .optional()
      .describe("Base ref to compare from (e.g. 'HEAD~1', 'main')"),
    to: tool.schema
      .string()
      .optional()
      .describe("Target ref to compare to (default: working tree or HEAD if --staged)"),
  },
  async execute(args, context) {
    const gitArgs = ["diff"]

    if (args.staged) {
      gitArgs.push("--staged")
    }

    if (args.from) {
      gitArgs.push(args.from)
    }
    if (args.to) {
      gitArgs.push(args.to)
    }

    if (args.file) {
      gitArgs.push("--", args.file)
    }

    const proc = await new Bun.Command("git", gitArgs, {
      cwd: context.worktree,
    })

    if (!proc.success) {
      return `Error: ${proc.stderr.toString().trim()}`
    }

    const output = proc.stdout.toString().trim()
    if (!output) {
      return "No differences found."
    }

    return output
  },
})
