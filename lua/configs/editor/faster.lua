return function()
	require("utils").load_plugin("faster", {
		behaviours = {
			bigfile = {
				on = true,
				features_disabled = {
					"filetype",
					"indent_blankline",
					"lsp",
					"matchparen",
					"syntax",
					"treesitter",
					"vimopts",
				},
				filesize = 2, -- size of the file in MiB
			},
			fastmacro = {
				on = true,
				features_disabled = { "lualine" },
			},
		},
		features = {
			filetype = {
				on = true,
				defer = true,
			},
			indent_blankline = {
				on = true,
				defer = false,
			},
			lsp = {
				on = true,
				defer = false,
			},
			lualine = {
				on = true,
				defer = false,
			},
			matchparen = {
				on = true,
				defer = false,
			},
			syntax = {
				on = true,
				defer = true,
			},
			treesitter = {
				on = true,
				defer = false,
			},
			vimopts = {
				on = true,
				defer = false,
			},
		},
	})
end
