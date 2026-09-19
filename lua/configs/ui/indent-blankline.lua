return function()
	local icons = { ui = require("icons").get("ui", true) }

	require("utils").load_plugin("ibl", {
		enabled = true,
		debounce = 200,
		indent = {
			char = "│",
			tab_char = "│",
			smart_indent_cap = true,
			priority = 2,
		},
		whitespace = { remove_blankline_trail = true },
		-- Note: The `scope` field requires treesitter to be set up
		scope = {
			enabled = true,
			char = "┃",
			show_start = false,
			show_end = false,
			injected_languages = true,
			priority = 1000,
			include = {
				node_type = {
					c = {
						"case_statement",
						"compound_literal_expression",
						"enumerator_list",
						"field_declaration_list",
						"initializer_list",
						"init_declarator",
					},
					lua = {
						"arguments",
						"field",
						"method_index_expression",
						"return_statement",
						"table_constructor",
					},
					python = {
						"argument_list",
						"class_definition",
						"compound_statement",
						"decorated_definition",
						"dictionary",
						"lambda",
						"list",
						"named_parameter",
						"set",
						"subscript_list",
						"tuple",
					},
					rust = {
						"enum_variant",
						"function_signature",
						"impl_item",
						"struct_item",
						"trait_item",
					},
				},
			},
		},
		exclude = {
			buftypes = {
				"help",
				"nofile",
				"prompt",
				"quickfix",
				"terminal",
			},
			filetypes = {
				"", -- for all buffers without a file type
				"alpha",
				"checkhealth",
				"diff",
				"fugitive",
				"fugitiveblame",
				"git",
				"gitcommit",
				"help",
				"log",
				"markdown",
				"NvimTree",
				"qf",
				"TelescopePrompt",
				"text",
				"undotree",
				"vimwiki",
			},
		},
	})
end
