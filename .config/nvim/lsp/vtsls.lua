local mise = require("bearguns.mise")
local vue_server_root = mise.where("npm:@vue/language-server")
local global_plugins = {}

if vue_server_root then
	table.insert(global_plugins, {
		name = "@vue/typescript-plugin",
		location = vue_server_root .. "/lib/node_modules/@vue/language-server",
		languages = { "vue" },
		configNamespace = "typescript",
	})
end

return {
	cmd = mise.command("vtsls", { "--stdio" }),
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	init_options = {
		hostInfo = "neovim",
	},
	root_dir = function(bufnr, on_dir)
		local root_markers = {
			{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
			{ ".git" },
		}
		local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
		local project_root = vim.fs.root(bufnr, root_markers)

		if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
			return
		end
		if deno_root and (not project_root or #deno_root >= #project_root) then
			return
		end

		on_dir(project_root or vim.fn.getcwd())
	end,
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = global_plugins,
			},
		},
		typescript = {
			tsserver = { maxTsServerMemory = 8192 },
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
			preferences = {
				includeCompletionsForModuleExports = true,
				includeCompletionsWithInsertText = true,
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayParameterTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = false,
			},
		},
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
		},
	},
}
