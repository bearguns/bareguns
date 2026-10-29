-- Close and rename paired JSX/TSX/HTML tags.
return {
	"windwp/nvim-ts-autotag",
	config = function()
		require("nvim-ts-autotag").setup()
	end,
}
