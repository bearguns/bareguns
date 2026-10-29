vim.lsp.enable({ "vtsls", "vue_ls", "tailwindcss", "lua_ls", "sourcekit" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		-- LSP autotrigger normally only reacts to server-defined characters such
		-- as ".". Include every printable character for completion as you type.
		if client:supports_method("textDocument/completion") then
			local trigger_characters = {}
			for char = 32, 126 do
				table.insert(trigger_characters, string.char(char))
			end
			client.server_capabilities.completionProvider.triggerCharacters = trigger_characters
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		-- Inlay hints (opt-in)
		if client:supports_method("textDocument/inlayHint") and vim.g.auto_inlay_hint then
			vim.lsp.inlay_hint.enable()
		end

		-- Custom keymaps beyond the built-in defaults (:h lsp-defaults)
		-- Built-in: K=hover, gra=code_action, grn=rename, grr=references,
		--           gri=implementation, grt=type_definition, gO=document_symbol,
		--           C-S=signature_help, document_color=enabled

		if client:supports_method("textDocument/declaration") then
			vim.keymap.set("n", "gD", function()
				vim.lsp.buf.declaration({ bufnr = ev.buf })
			end, { buffer = ev.buf })
		end

		vim.keymap.set("n", "gl", function()
			vim.diagnostic.open_float({ bufnr = ev.buf, border = "rounded" })
		end, { buffer = ev.buf, desc = "Open diagnostic float" })
	end,
})
