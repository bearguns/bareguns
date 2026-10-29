local sync_group = vim.api.nvim_create_augroup("external_file_sync", { clear = true })

local function check_for_external_changes()
	if vim.v.exiting ~= vim.NIL then
		return
	end

	vim.cmd("silent! checktime")
end

-- Focus events make returning from a Codex tmux pane feel immediate. BufEnter
-- also covers switching among files inside Neovim.
vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave", "BufEnter" }, {
	group = sync_group,
	callback = check_for_external_changes,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	group = sync_group,
	callback = function(ev)
		vim.notify(("Reloaded external changes: %s"):format(vim.fn.fnamemodify(ev.file, ":~:.")))
	end,
})

vim.api.nvim_create_user_command("SyncExternalChanges", check_for_external_changes, {
	desc = "Reload files changed outside Neovim when their buffers are clean",
})
