import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Validate that the Nix flake evaluates without errors. Runs `nix flake check` to verify all configurations, packages, and dev shells build correctly.",
  args: {
    host: tool.schema
      .string()
      .optional()
      .describe(
        "Specific NixOS or home-manager host to check (e.g. 'beehive', 'salacia', 'keanu@titan'). Omit to check the entire flake.",
      ),
    build: tool.schema
      .boolean()
      .optional()
      .describe(
        "Also attempt a build (nix build) instead of just eval checking. Slower but more thorough.",
      ),
  },
  async execute(args, context) {
    if (args.host && args.build) {
      const buildProc = await new Bun.Command("nix", [
        "build",
        `.#${args.host}`,
        "--no-link",
      ], {
        cwd: context.worktree,
      })

      if (!buildProc.success) {
        return `Build failed for '${args.host}':\n${buildProc.stderr.toString().trim()}`
      }
      return `Build succeeded for '${args.host}'`
    }

    if (args.host) {
      const evalProc = await new Bun.Command("nix", [
        "eval",
        `.#${args.host}`,
        "--json",
      ], {
        cwd: context.worktree,
      })

      if (!evalProc.success) {
        return `Evaluation failed for '${args.host}':\n${evalProc.stderr.toString().trim()}`
      }
      return `Evaluation succeeded for '${args.host}'`
    }

    const checkProc = await new Bun.Command("nix", [
      "flake",
      "check",
      "--no-build",
    ], {
      cwd: context.worktree,
    })

    if (!checkProc.success) {
      return `Flake check failed:\n${checkProc.stderr.toString().trim()}`
    }
    return "Flake check passed — all configurations evaluate successfully."
  },
})