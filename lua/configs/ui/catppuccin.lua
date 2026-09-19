return function()
	local transparent_background = vim.g.my_settings.transparent_background

	require("utils").load_plugin("catppuccin", {
		background = { light = "latte", dark = "mocha" },
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		transparent_background = transparent_background,
		show_end_of_buffer = false,
		term_colors = true,
		compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		styles = {
			comments = { "italic" },
			functions = { "bold" },
			keywords = { "italic" },
			operators = { "bold" },
			conditionals = { "bold" },
			loops = { "bold" },
			booleans = { "bold", "italic" },
		},
		integrations = {
			blink_cmp = true,
			flash = true,
			fzf = true,
			gitsigns = true,
			indent_blankline = { enabled = true, colored_indent_levels = true },
			mason = true,
			mini = { enabled = true },
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
			},
			nvimtree = true,
			rainbow_delimiters = true,
			render_markdown = true,
			semantic_tokens = true,
			telescope = { enabled = true, style = "nvchad" },
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
		highlight_overrides = {
			---@param cp table
			all = function(cp)
				return {
					NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
					FloatBorder = {
						fg = transparent_background and cp.blue or cp.mantle,
						bg = transparent_background and cp.none or cp.mantle,
					},
					CursorLineNr = { fg = cp.green },

					-- native LSP
					DiagnosticVirtualTextError = { bg = cp.none },
					DiagnosticVirtualTextWarn = { bg = cp.none },
					DiagnosticVirtualTextInfo = { bg = cp.none },
					DiagnosticVirtualTextHint = { bg = cp.none },
					LspInfoBorder = { link = "FloatBorder" },

					-- mason.nvim
					MasonNormal = { link = "NormalFloat" },

					-- indent-blankline
					IblIndent = { fg = cp.surface0 },
					IblScope = { fg = cp.surface2, style = { "bold" } },

					-- completion menu
					Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
					PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
					PmenuSel = { bg = cp.green, fg = cp.base },
					CmpItemAbbr = { fg = cp.overlay2 },
					CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
					CmpDoc = { link = "NormalFloat" },
					CmpDocBorder = {
						fg = transparent_background and cp.surface1 or cp.mantle,
						bg = transparent_background and cp.none or cp.mantle,
					},
				}
			end,
		},
	})
end
