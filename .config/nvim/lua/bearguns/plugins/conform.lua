return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters = {
				prettier = {
					require_cwd = true,
				},
			},
			formatters_by_ft = {
				javascript = { "oxfmt", "oxlint" },
				javascriptreact = { "oxfmt", "oxlint" },
				typescript = { "oxfmt", "oxlint" },
				typescriptreact = { "oxfmt", "oxlint" },
				css = { "oxfmt" },
				html = { "oxfmt" },
				json = { "oxfmt", "oxlint" },
				yaml = { "oxfmt" },
				lua = { "stylua" },
				vue = { "oxfmt", "oxlint" },
				svelte = { "oxfmt", "oxlint" },
			},
			format_on_save = {
				async = false,
				timeout_ms = 1000,
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>T", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range" })
	end,
}
