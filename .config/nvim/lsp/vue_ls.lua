local mise = require("bearguns.mise")

return {
	cmd = mise.command("vue-language-server", { "--stdio" }),
	filetypes = { "vue" },
	root_markers = { "vue.config.js", "vue.config.ts", "nuxt.config.js", "nuxt.config.ts", "package.json" },
	on_init = function(client)
		local retries = 0

		local function forward_typescript_request(_, result, context)
			local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })[1]
			if not ts_client then
				if retries <= 10 then
					retries = retries + 1
					vim.defer_fn(function()
						forward_typescript_request(_, result, context)
					end, 100)
				else
					vim.notify(
						"Could not find `vtsls` LSP client; Vue TypeScript features are unavailable.",
						vim.log.levels.ERROR
					)
				end
				return
			end

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "Vue LS <> TS Handoff",
				command = "typescript.tsserverRequest",
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, response)
				local response_data = { { id, response and response.body } }
				---@diagnostic disable-next-line: param-type-mismatch
				client:notify("tsserver/response", response_data)
			end)
		end

		client.handlers["tsserver/request"] = forward_typescript_request
	end,
}
