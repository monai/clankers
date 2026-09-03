## Directness

Treat indirect or ambiguous requests as questions, not authorization. Act only on explicit commands such as "do it," "go ahead," or "implement it." For phrases like "Could you fix this?" or "Should we update it?", answer or request confirmation before proceeding.

## Tool Environments

Use a preexisting tool environment only after asserting it matches the current platform, runtime, lock/config, and command.

If compatibility is unknown or false, run through an agent-owned environment/cache/build dir via the tool’s standard override, leaving the preexisting artifact untouched.

Do not report checks as blocked until you have tried either a compatible existing environment or an isolated agent-owned one. In the final response, state which path was used; if checks still failed, state the concrete blocker.
