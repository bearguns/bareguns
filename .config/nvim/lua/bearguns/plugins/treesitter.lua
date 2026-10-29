return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Treesitter: parser installation only.
		-- After installing parsers via :TSInstall, highlighting is enabled via
		-- vim.treesitter.start() below. See :h treesitter-highlight
		require("nvim-treesitter").setup()

		-- Enable treesitter highlighting for filetypes we use.
		-- Lua, markdown, and help are handled by Neovim's built-in ftplugins.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"javascript", "javascriptreact", "typescript", "typescriptreact",
				"vue", "svelte", "html", "css", "json", "yaml", "bash", "python", "gitignore",
			},
			callback = function(ev)
				if vim.treesitter.language.add(vim.treesitter.language.get_lang(ev.match) or ev.match) then
					vim.treesitter.start(ev.buf)
				end
			end,
		})
	end,
}
