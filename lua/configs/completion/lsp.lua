return function()
	-- Mason-installed servers: ensure the lsp_deps are installed and
	-- register each with capabilities (see mason-lspconfig.lua).
	require("configs.completion.mason-lspconfig").setup()
	-- User-defined servers that mason does not manage (harper_ls, nushell, ...).
	require("configs.completion.user-servers").setup()

	-- Start any already-configured server.
	pcall(vim.cmd.LspStart)
end
