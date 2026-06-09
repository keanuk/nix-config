import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Search file contents across the project using ripgrep (or grep). Useful for finding symbols, usages, references, or patterns in the codebase.",
  args: {
    pattern: tool.schema
      .string()
      .describe("Regex or string pattern to search for"),
    path: tool.schema
      .string()
      .optional()
      .describe("Limit search to a specific directory or file"),
    case_sensitive: tool.schema
      .boolean()
      .optional()
      .describe("Case-sensitive search (default: false)"),
    max_results: tool.schema
      .number()
      .optional()
      .describe("Maximum number of results to return (default: 30)"),
  },
  async execute(args, context) {
    const maxResults = args.max_results ?? 30
    const searchPattern = args.pattern
    const searchPath = args.path
    const caseSensitive = args.case_sensitive ?? false

    const rgCheck = await new Bun.Command("rg", ["--version"], {
      cwd: context.worktree,
    }).safe()

    let proc
    if (rgCheck.success) {
      const rgArgs = [
        "--line-number",
        "--max-count",
        String(maxResults),
        ...(caseSensitive ? [] : ["--ignore-case"]),
        searchPattern,
      ]
      if (searchPath) rgArgs.push(searchPath)
      proc = await new Bun.Command("rg", rgArgs, {
        cwd: context.worktree,
      }).safe()
    } else {
      const grepArgs = [
        "-r",
        "-n",
        ...(caseSensitive ? [] : ["-i"]),
        "--max-count",
        String(maxResults),
        searchPattern,
        searchPath ?? ".",
      ]
      proc = await new Bun.Command("grep", grepArgs, {
        cwd: context.worktree,
      }).safe()
    }

    if (!proc.success) {
      if (proc.exitCode === 1) {
        return `No matches found for '${searchPattern}'.`
      }
      return `Error searching: ${proc.stderr.toString().trim()}`
    }

    const output = proc.stdout.toString().trim()
    if (!output) {
      return `No matches found for '${searchPattern}'.`
    }

    return output
  },
})
