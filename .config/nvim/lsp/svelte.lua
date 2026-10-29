local mise = require("bearguns.mise")

return {
	cmd = mise.command("svelteserver", { "--stdio" }),
	filetypes = { "svelte" },
	root_markers = { "svelte.config.js", "svelte.config.ts", "package.json", ".git" },
}
