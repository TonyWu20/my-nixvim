return function()
	local null_ls = require("null-ls")
	local btns = null_ls.builtins

	local sources = {
		btns.formatting.clang_format.with({
			filetypes = { "c", "cpp", "objc", "objcpp", "cs", "cuda", "proto" },
		}),
		btns.formatting.prettier.with({
			filetypes = {
				"vue",
				"typescript",
				"javascript",
				"typescriptreact",
				"javascriptreact",
				"yaml",
				"html",
				"css",
				"scss",
				"sh",
				"markdown",
			},
		}),
	}

	require("utils").load_plugin("null-ls", {
		border = "rounded",
		debug = false,
		log_level = "warn",
		update_in_insert = false,
		sources = sources,
		default_timeout = vim.g.my_settings.format_timeout,
	})

	require("configs.completion.mason-null-ls").setup()
	require("configs.completion.formatting").configure_format_on_save()
end
