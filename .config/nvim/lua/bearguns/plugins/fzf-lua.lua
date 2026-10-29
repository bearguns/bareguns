return {
	"ibhagwan/fzf-lua",
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({
			winopts = {
				preview = { default = "builtin" },
			},
		})
		vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>pf", fzf.git_files, { desc = "Git files" })
		vim.keymap.set("n", "<leader>pg", fzf.live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>bb", fzf.buffers, { desc = "Buffers" })
	end,
}
