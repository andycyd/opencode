// this is an opencode plugin - https://opencode.ai/docs/plugins/
// that will emit the BEL character on certain events (when the agent asks me questions, for example)
// which should make most modern terminals emit some kind of notification (beep, flash, etc.)
// Windows Terminal docs: https://learn.microsoft.com/en-us/windows/terminal/customize-settings/profile-advanced#bell-notification-style

export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    event: async ({ event }) => {
      // send notification on session completion
      if (event.type === "session.idle"
        || event.type === "session.error"
        || event.type === "permission.asked"
        || event.type === "question.asked"
      ) {
        process.stdout.write("\x07");
      }
    },
  }
}