-- Register LSP servers defined under lua/user/lsp-servers/*.lua.
--
-- Each file is named after its lspconfig server name (e.g. harper_ls.lua,
-- nushell.lua) and must return either:
--   * a table  : merged over the lspconfig default config for that server, or
--   * a function(opts): custom setup that calls `vim.lsp.config()` itself.
--
-- Note: servers that are installed via mason are handled by
-- configs/completion/mason-lspconfig.lua instead. Use this directory for
-- servers that mason does not manage (or extra per-server tweaks).

local M = {}

function M.setup()
	local files = vim.fn.glob(vim.g.my_globals.vim_path .. "/lua/user/lsp-servers/*.lua", false, true)
	if files[#files] == "" then
		table.remove(files)
	end
	for _, file in ipairs(files) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		local ok, cfg = pcall(require, "user.lsp-servers." .. name)
		if not ok then
			vim.notify(string.format("Cannot load user lsp server [%s]: %s", name, cfg), vim.log.levels.ERROR)
		elseif type(cfg) == "table" then
			local opts = { capabilities = require("utils").get_lsp_capabilities() }
			vim.tbl_deep_extend("force", opts, cfg)
			vim.lsp.config(name, opts)
			vim.lsp.enable(name)
		elseif type(cfg) == "function" then
			cfg()
		end
	end
end

return M
