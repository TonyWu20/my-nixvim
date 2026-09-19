local M = {}

function M.setup()
	local lsp_deps = vim.g.my_settings.lsp_deps
	local mason_registry = require("mason-registry")
	local mason_lspconfig = require("mason-lspconfig")

	require("utils").load_plugin("mason-lspconfig", {
		ensure_installed = lsp_deps,
		-- Skip auto enable because we are loading language servers lazily
		automatic_enable = false,
	})

	vim.diagnostic.config({
		signs = true,
		underline = true,
		virtual_text = false,
		update_in_insert = false,
	})

	local opts = {
		capabilities = require("utils").get_lsp_capabilities(),
	}

	---A handler to setup servers resolved from installed mason packages.
	---@param lsp_name string
	local function mason_lsp_handler(lsp_name)
		-- rust_analyzer is configured by mrcjkb/rustaceanvim, not mason-lspconfig.
		if lsp_name == "rust_analyzer" then
			return
		end

		local ok, custom_handler = pcall(require, "user.lsp-servers." .. lsp_name)
		if not ok then
			-- Default: use the lspconfig factory config for servers without a custom spec.
			require("utils").register_server(lsp_name, opts)
			return
		end

		if type(custom_handler) == "function" then
			-- The server requires its own setup and must call `vim.lsp.config()` inside.
			custom_handler(opts)
			vim.lsp.enable(lsp_name)
		elseif type(custom_handler) == "table" then
			require("utils").register_server(lsp_name, vim.tbl_deep_extend("force", opts, custom_handler))
		else
			vim.notify(
				string.format("user.lsp-servers.%s must return a function or a table", lsp_name),
				vim.log.levels.ERROR,
				{ title = "nvim-lspconfig" }
			)
		end
	end

	-- Build the mason-package -> lspconfig-name mapping once.
	local mappings = mason_lspconfig.get_mappings().package_to_lspconfig
	if not mappings or vim.tbl_isempty(mappings) then
		mappings = {}
		for _, spec in ipairs(mason_registry.get_all_package_specs()) do
			local lspconfig = vim.tbl_get(spec, "neovim", "lspconfig")
			if lspconfig then
				mappings[spec.name] = lspconfig
			end
		end
	end

	-- Enable only the servers in the user's lsp_deps. Other installed
	-- mason packages (formatters such as stylua) must not become LSP clients.
	for _, pkg in ipairs(mason_registry.get_installed_package_names()) do
		local name = type(pkg) == "string" and pkg or pkg.name
		local srv = mappings[name]
		if srv and vim.tbl_contains(lsp_deps, srv) then
			mason_lsp_handler(srv)
		end
	end
end

return M
