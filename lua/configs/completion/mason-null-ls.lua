local M = {}

function M.setup()
	require("utils").load_plugin("mason-null-ls", {
		ensure_installed = vim.g.my_settings.null_ls_deps,
		automatic_installation = false,
		automatic_setup = true,
		handlers = {},
	})
end

return M
