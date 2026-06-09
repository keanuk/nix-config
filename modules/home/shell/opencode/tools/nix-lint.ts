import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Run the project's Nix linting suite (nix fmt, deadnix, statix check) on a file or directory. Use this after modifying any .nix file.",
  args: {
    path: tool.schema
      .string()
      .describe("Path to the .nix file or directory to lint, relative to project root"),
  },
  async execute(args, context) {
    const target = args.path
    const results: string[] = []

    // nix fmt
    const fmtArgs = ["fmt"]
    if (target) fmtArgs.push(target)
    const fmtProc = await new Bun.Command("nix", fmtArgs, {
      cwd: context.worktree,
    }).safe()

    if (!fmtProc.success) {
      results.push(`nix fmt failed:\n${fmtProc.stderr.toString().trim()}`)
    } else {
      results.push("nix fmt: passed")
    }

    // deadnix
    const deadnixProc = await new Bun.Command("deadnix", [target], {
      cwd: context.worktree,
    }).safe()

    if (!deadnixProc.success) {
      results.push(`deadnix failed:\n${deadnixProc.stderr.toString().trim()}`)
    } else {
      results.push("deadnix: passed")
    }

    // statix check
    const statixProc = await new Bun.Command("statix", ["check", target], {
      cwd: context.worktree,
    }).safe()

    if (!statixProc.success) {
      results.push(`statix check failed:\n${statixProc.stderr.toString().trim()}`)
    } else {
      results.push("statix check: passed")
    }

    return results.join("\n")
  },
})
