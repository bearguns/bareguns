# Global Agent Instructions
- Never use the `as` keyword in TypeScript, find the correct way to type the code.
- When working on large code changes in sequence, prompt me for feedback after each logical chunk i.e. per function, VueJS composable, React component. Allow me time to review and provide feedback.
- Don't prioritize development cost. Focus on quality, clarity, simplicity, robustness, and resilience.
- NEVER include your name or "Co-authored by [AGENT]" in commit messages.
- When doing bug fixes, start by reproducing the bug in a test environment or via controlled unit or e2e tests, to ensure you encounter the same issue as an actual user.
- Before using any "ultracode", "superpower", or other heavy, multi-agent workflow, you MUST stop and ask for explicit permission to continue.

## VueJS Instructions
- **USE THE [FRIENDLY] FRAMEWORK**. `ref`, `computed`, `watch`/`watchEffect` can probably accomplish what you need.
- Be _declarative_. "Describe" the final state of the component or UI using `ref`, `computed`, `watch`, and `<template>`. You shouldn't have to "do" a lot to make the UI update.
- Don't write a separate composable for a single component's state or logic, if you can split the component up into smaller logical containers.
- Props down, events up.
- Too many props is a smell.

