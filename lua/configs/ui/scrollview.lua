return function()
	local icons = { diagnostics = require("icons").get("diagnostics", true) }

	require("utils").load_plugin("scrollview", {
		mode = "virtual",
		winblend = 0,
		signs_on_startup = { "folds", "marks", "search" },
		diagnostics_error_symbol = icons.diagnostics.Error,
		diagnostics_warn_symbol = icons.diagnostics.Warning,
		diagnostics_info_symbol = icons.diagnostics.Information,
		diagnostics_hint_symbol = icons.diagnostics.Hint,
		excluded_filetypes = {
			"alpha",
			"fugitive",
			"git",
			"NvimTree",
			"TelescopePrompt",
		},
	})
end
