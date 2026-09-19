return function()
	vim.g.rustaceanvim = {
		-- Disable automatic DAP configuration to avoid conflicts.
		dap = {
			adapter = false,
			configuration = false,
			autoload_configurations = false,
		},
		server = {
			standalone = true,
			default_settings = {
				["rust-analyzer"] = {
					-- User preference carried over from the old config.
					checkOnSave = { allFeatures = true, command = "cargo check" },
					procMacro = { enable = true },
					completion = { autoimport = true },
					files = { excludeDirs = { ".direnv" } },
				},
			},
		},
	}

	require("utils").load_plugin("rustaceanvim", nil, true)
end
