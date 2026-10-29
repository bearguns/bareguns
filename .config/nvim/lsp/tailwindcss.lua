local mise = require("bearguns.mise")

return {
	cmd = mise.command("tailwindcss-language-server", { "--stdio" }),
	filetypes = {
		"html",
		"css",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.mjs", "package.json" },
}
