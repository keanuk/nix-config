import { tool } from "@opencode-ai/plugin"

export default tool({
  description:
    "List available just recipes or run a specific recipe. Just is a command runner — the project uses it for common tasks like building, checking, and deploying.",
  args: {
    recipe: tool.schema
      .string()
      .optional()
      .describe(
        "Recipe name to run (e.g. 'check', 'build', 'deploy', 'home'). Omit to list available recipes.",
      ),
    args_list: tool.schema
      .array(tool.schema.string())
      .optional()
      .describe("Arguments to pass to the recipe"),
  },
  async execute(args, context) {
    if (!args.recipe) {
      const proc = await new Bun.Command("just", ["--list"], {
        cwd: context.worktree,
      })

      if (!proc.success) {
        return `Error listing recipes: ${proc.stderr.toString().trim()}\n\nIs 'just' installed? Is there a justfile in the project root?`
      }

      return proc.stdout.toString().trim()
    }

    const recipeArgs = [args.recipe, ...(args.args_list ?? [])]

    const proc = await new Bun.Command("just", recipeArgs, {
      cwd: context.worktree,
    })

    const stdout = proc.stdout.toString().trim()
    const stderr = proc.stderr.toString().trim()

    if (!proc.success) {
      return `Recipe '${args.recipe}' failed:\n${stderr || stdout}`
    }

    return stdout || `Recipe '${args.recipe}' completed successfully.`
  },
})