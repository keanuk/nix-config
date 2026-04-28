import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "Evaluate a Nix flake attribute to check its value. Useful for verifying config settings, checking package versions, or inspecting option values before building.",
  args: {
    attribute: tool.schema
      .string()
      .describe(
        "Nix attribute path to evaluate (e.g. 'nixosConfigurations.beehive.config.networking.hostName', 'nixosConfigurations.titan.config.services.nginx.enable')",
      ),
    flake: tool.schema
      .string()
      .optional()
      .describe("Path to the flake (default: current directory)"),
  },
  async execute(args, context) {
    const flakeRef = args.flake ?? "."

    const proc = await new Bun.Command("nix", [
      "eval",
      `${flakeRef}#${args.attribute}`,
      "--raw",
    ], {
      cwd: context.worktree,
    })

    if (!proc.success) {
      const rawProc = await new Bun.Command("nix", [
        "eval",
        `${flakeRef}#${args.attribute}`,
      ], {
        cwd: context.worktree,
      })

      if (!rawProc.success) {
        return `Error evaluating '${args.attribute}':\n${proc.stderr.toString().trim()}`
      }

      return rawProc.stdout.toString().trim()
    }

    return proc.stdout.toString().trim()
  },
})