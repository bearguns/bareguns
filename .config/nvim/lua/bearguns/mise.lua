local M = {}

---Build an LSP command that resolves the executable from the active Mise tools.
---@param executable string
---@param args? string[]
---@return string[]
function M.command(executable, args)
	return vim.list_extend({ "mise", "exec", "--", executable }, args or {})
end

---Return the install root for a Mise tool, if it is installed.
---@param tool string
---@return string?
function M.where(tool)
	local result = vim.system({ "mise", "where", tool }, { text = true }):wait()
	if result.code ~= 0 then
		return nil
	end

	return vim.trim(result.stdout)
end

return M
