return function()
	local icons = {
		diagnostics = require("icons").get("diagnostics"),
		documents = require("icons").get("documents"),
		git = require("icons").get("git", true),
		ui = require("icons").get("ui", true),
	}

	require("utils").load_plugin("nvim-tree", {
		-- v1.6 schema: diagnostics are disabled in the tree.
		diagnostics = {
			enable = false,
			show_on_dirs = false,
		},
		filters = {
			enable = true,
			dotfiles = false,
			git_clean = false,
			git_ignored = true,
			no_buffer = false,
			no_bookmark = false,
			custom = { ".DS_Store" },
		},
		git = {
			enable = true,
			show_on_dirs = true,
			-- Untracked/modified files are surfaced by the git decorators and
			-- `renderer.icons.show.git` below, not via dedicated options in v1.6.
		},
		hijack_netrw = false,
		hijack_cursor = true,
		-- `filesystem_watchers` (enabled by default) gives the live-reload
		-- behaviour the old `helpers.use_libuv_filesystem_events` provided.
		filesystem_watchers = {
			enable = true,
		},
		respect_buf_cwd = true,
		prefer_startup_root = false,
		sync_root_with_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = { enable = true },
		},
		actions = {
			use_system_clipboard = true,
			change_dir = {
				enable = true,
				global = false,
			},
			open_file = {
				quit_on_open = false,
				resize_window = true,
				window_picker = {
					enable = true,
					chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
					exclude = {
						buftype = {
							"help",
							"nofile",
							"prompt",
							"quickfix",
							"terminal",
						},
						filetype = {
							"dap-repl",
							"diff",
							"fugitive",
							"fugitiveblame",
							"git",
							"gitcommit",
							"gitfugitive",
							"help",
							"log",
							"notify",
							"NvimTree",
							"Outline",
							"qf",
							"TelescopePrompt",
							"toggleterm",
							"undotree",
						},
					},
				},
			},
			remove_file = {
				close_window = true,
			},
		},
		renderer = {
			indent_markers = {
				enable = true,
				inline_arrows = true,
			},
			group_empty = true,
			special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "CMakeLists.txt" },
			root_folder_label = ":.:s?.*?/..?",
			full_name = false,
			symlink_destination = true,
			highlight_git = "all",
			icons = {
				-- Use the config's own glyph set instead of the default
				-- nvim-web-devicons rendering.
				web_devicons = {
					file = { enable = false },
					folder = { enable = false },
				},
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
				},
				padding = {
					icon = " ",
					folder_arrow = " ",
				},
				symlink_arrow = " 󰁔 ",
				glyphs = {
					default = icons.documents.Default,
					symlink = icons.documents.Symlink,
					bookmark = icons.ui.BookMark,
					folder = {
						arrow_open = icons.ui.ArrowOpen,
						arrow_closed = icons.ui.ArrowClosed,
						default = icons.ui.Folder,
						open = icons.ui.FolderOpen,
						empty = icons.ui.EmptyFolder,
						empty_open = icons.ui.EmptyFolderOpen,
						symlink = icons.ui.SymlinkFolder,
						symlink_open = icons.ui.FolderOpen,
					},
					-- Git status glyphs. v1.6 nests these under `glyphs.git`.
					git = {
						renamed = icons.git.Rename,
						untracked = icons.git.Untracked,
						deleted = icons.git.Remove,
						ignored = icons.git.Ignore,
						unstaged = icons.git.Mod_alt,
						staged = icons.git.Add,
					},
				},
			},
		},
	})
end
