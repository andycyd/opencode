// this is an opencode plugin - https://opencode.ai/docs/plugins/
// that will prevent .env files from being read

export const EnvFileProtectionPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "read" && output.args.filePath.includes(".env")) {
        throw new Error("Do not read .env files")
      }
    },
  }
}