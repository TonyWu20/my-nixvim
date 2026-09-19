-- Keybindings. A single module, set via `vim.keymap.set`.
--
-- Layout mirrors the old config: editing builtins, plugin maps, and
-- buffer-scoped handlers (gitsigns, LSP). The user override pass runs
-- last, so `lua/user/keymap/*.lua` can add, replace, or remove maps.

local M = {}

---Register a keymap with the shared defaults.
---@param mode string|string[]
---@param lhs string
---@param rhs string|fun()
---@param desc? string
local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, {
		noremap = true,
		silent = true,
		nowait = true,
		desc = desc,
	})
end

---Register a command (ex-command string) keymap.
local function map_cmd(mode, lhs, cmd, desc)
	map(mode, lhs, cmd, desc)
end

----------------------------------------------------------------------
--                        Package manager                          --
----------------------------------------------------------------------
map("n", "<leader>ph", ":Lazy", "package: Show")
map("n", "<leader>ps", ":Lazy sync", "package: Sync")
map("n", "<leader>pu", ":Lazy update", "package: Update")
map("n", "<leader>pi", ":Lazy install", "package: Install")
map("n", "<leader>pl", ":Lazy log", "package: Log")
map("n", "<leader>pc", ":Lazy check", "package: Check")
map("n", "<leader>pd", ":Lazy debug", "package: Debug")
map("n", "<leader>pp", ":Lazy profile", "package: Profile")
map("n", "<leader>pr", ":Lazy restore", "package: Restore")
map("n", "<leader>px", ":Lazy clean", "package: Clean")

----------------------------------------------------------------------
--                     Built-in editing maps                      --
----------------------------------------------------------------------
-- Save & quit
map("n", "<C-s>", ":w<CR>", "edit: Save file")
map("n", "<C-q>", ":wq<CR>", "edit: Save file and quit")
map("n", "<A-S-q>", ":q!<CR>", "edit: Force quit")

-- Insert mode
map("i", "<C-u>", "<C-G>u<C-U>", "edit: Delete previous block")
map("i", "<C-b>", "<Left>", "edit: Move cursor to left")
map("i", "<C-a>", "<ESC>^i", "edit: Move cursor to line start")
map("i", "<C-s>", "<Esc>:w<CR>", "edit: Save file")
map("i", "<C-q>", "<Esc>:wq<CR>", "edit: Save file and quit")

-- Command mode
map("c", "<C-b>", "<Left>", "edit: Left")
map("c", "<C-f>", "<Right>", "edit: Right")
map("c", "<C-a>", "<Home>", "edit: Home")
map("c", "<C-e>", "<End>", "edit: End")
map("c", "<C-d>", "<Del>", "edit: Delete")
map("c", "<C-h>", "<BS>", "edit: Backspace")
map("c", "<C-t>", [[<C-R>=expand("%:p:h") . "/" <CR>]], "edit: Complete path of current file")

-- Visual mode
map("v", "J", ":m '>+1<CR>gv=gv", "edit: Move this line down")
map("v", "K", ":m '<-2<CR>gv=gv", "edit: Move this line up")
map("v", "<", "<gv", "edit: Decrease indent")
map("v", ">", ">gv", "edit: Increase indent")

-- "Suckless"
map("n", "Y", "y$", "edit: Yank text to EOL")
map("n", "D", "d$", "edit: Delete text to EOL")
map("n", "n", "nzzzv", "edit: Next search result")
map("n", "N", "Nzzzv", "edit: Prev search result")
map("n", "J", "mzJ`z", "edit: Join next line")
map("n", "<S-Tab>", "<Cmd>normal za<CR>", "edit: Toggle code fold")
map("n", "<Esc>", function()
	-- Clear the search highlight without the flash side effect.
	vim.cmd("noh")
end, "edit: Clear search highlight")
map("n", "<leader>o", ":setlocal spell! spelllang=en_us<CR>", "edit: Toggle spell check")

----------------------------------------------------------------------
--                            Plugins                              --
----------------------------------------------------------------------
-- comment.nvim
local function count_or(cur, cnt)
	return function()
		local lhs = vim.v.count == 0 and cur or cnt
		return vim.api.nvim_replace_termcodes(lhs, true, true, true)
	end
end
vim.keymap.set("n", "gcc", count_or("<Plug>(comment_toggle_linewise_current)", "<Plug>(comment_toggle_linewise_count)"),
	{ noremap = true, silent = true, expr = true, desc = "edit: Toggle comment for line" })
vim.keymap.set("n", "gbc", count_or("<Plug>(comment_toggle_blockwise_current)", "<Plug>(comment_toggle_blockwise_count)"),
	{ noremap = true, silent = true, expr = true, desc = "edit: Toggle comment for block" })
map("n", "gc", "<Plug>(comment_toggle_linewise)", "edit: Toggle comment for line with operator")
map("n", "gb", "<Plug>(comment_toggle_blockwise)", "edit: Toggle comment for block with operator")
map("x", "gc", "<Plug>(comment_toggle_linewise_visual)", "edit: Toggle comment for line with selection")
map("x", "gb", "<Plug>(comment_toggle_blockwise_visual)", "edit: Toggle comment for block with selection")

-- suda.vim
map("n", "<A-s>", ":SudaWrite", "edit: Save file using sudo")

-- nvim-treehopper
map("o", "m", ":lua require('tsht').nodes()", "jump: Operate across syntax tree")

-- nvim-bufdel
map("n", "<A-q>", ":BufDel", "buffer: Close current")

-- bufferline.nvim
map("n", "<A-i>", ":BufferLineCycleNext", "buffer: Switch to next")
map("n", "<A-o>", ":BufferLineCyclePrev", "buffer: Switch to prev")
map("n", "<A-S-i>", ":BufferLineMoveNext", "buffer: Move current to next")
map("n", "<A-S-o>", ":BufferLineMovePrev", "buffer: Move current to prev")
for i = 1, 9 do
	map("n", string.format("<A-%d>", i), string.format(":BufferLineGoToBuffer %d", i),
		"buffer: Goto buffer " .. i)
end

-- vim-fugitive
map("n", "gps", ":G push", "git: Push")
map("n", "gpl", ":G pull", "git: Pull")
map("n", "<leader>gG", ":Git", "git: Open git-fugitive")

-- nvim-tree
map("n", "<leader>nf", ":NvimTreeFindFile", "filetree: Find file")
map("n", "<leader>nr", ":NvimTreeRefresh", "filetree: Refresh")
map("n", "<leader>nt", ":NvimTreeToggle", "filetree: Toggle tree")

-- render-markdown
map("n", "<F1>", ":RenderMarkdown toggle", "tool: Toggle markdown preview within nvim")

-- formatter (null-ls / LSP)
map("n", "<A-f>", ":FormatToggle", "formatter: Toggle format on save")
map("n", "<A-S-f>", ":Format", "formatter: Format buffer manually")

----------------------------------------------------------------------
--                          Telescope                              --
----------------------------------------------------------------------
map("n", "<leader>ff", function()
	require("search").open({ collection = "file" })
end, "tool: Find files")
map("n", "<leader>fp", function()
	require("search").open({ collection = "pattern" })
end, "tool: Find patterns")
map("v", "<leader>fs", function()
	local ok, lga = pcall(require, "telescope-live-grep-args.shortcuts")
	if ok then
		lga.grep_visual_selection()
	end
end, "tool: Grep visual selection")
map("n", "<leader>fr", ":Telescope resume", "tool: Resume last search")
map("n", "<C-p>", function()
	-- The built-in keymaps picker as the command panel.
	require("telescope.builtin").keys()
end, "tool: Toggle command panel")

----------------------------------------------------------------------
--                       User override pass                        --
----------------------------------------------------------------------
-- `lua/user/keymap/init.lua` (optional) returns a table keyed by
-- "<mode>|<lhs>": `false` removes the map, a string/function replaces it.
local ok, user_maps = pcall(require, "user.keymap.init")
if ok and type(user_maps) == "table" then
	for key, rhs in pairs(user_maps) do
		local sep = key:find("|", 1, true)
		if not sep then
			vim.notify(string.format("[keymaps] bad override key [%s]", key), vim.log.levels.WARN)
		else
			local mode = key:sub(1, sep - 1)
			local lhs = key:sub(sep + 1)
			if rhs == false or rhs == "" then
				vim.keymap.del(mode, lhs)
			else
				map(mode, lhs, rhs)
			end
		end
	end
end

----------------------------------------------------------------------
--                    Buffer-scoped handlers                       --
----------------------------------------------------------------------

---gitsigns on_attach handler (exported to the gitsigns config).
---@param bufnr integer
function M.gitsigns(bufnr)
	local gitsigns = require("gitsigns")
	local function bmap(mode, lhs, fn, desc, expr)
		local opts = { noremap = true, buffer = true, desc = desc }
		if expr then
			opts.expr = true
		end
		vim.keymap.set(mode, lhs, fn, opts)
	end

	bmap("n", "]g", function()
		if vim.wo.diff then
			return "]g"
		end
		vim.schedule(function()
			gitsigns.nav_hunk("next")
		end)
		return "<Ignore>"
	end, "git: Goto next hunk", true)
	bmap("n", "[g", function()
		if vim.wo.diff then
			return "[g"
		end
		vim.schedule(function()
			gitsigns.nav_hunk("prev")
		end)
		return "<Ignore>"
	end, "git: Goto prev hunk", true)
	bmap("n", "<leader>gs", function()
		gitsigns.stage_hunk()
	end, "git: Toggle staging/unstaging of hunk")
	bmap("v", "<leader>gs", function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, "git: Toggle staging/unstaging of selected hunk")
	bmap("n", "<leader>gr", function()
		gitsigns.reset_hunk()
	end, "git: Reset hunk")
	bmap("v", "<leader>gr", function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, "git: Reset hunk")
	bmap("n", "<leader>gR", function()
		gitsigns.reset_buffer()
	end, "git: Reset buffer")
	bmap("n", "<leader>gp", function()
		gitsigns.preview_hunk()
	end, "git: Preview hunk")
	bmap("n", "<leader>gb", function()
		gitsigns.blame_line({ full = true })
	end, "git: Blame line")
	bmap("o", "ih", function()
		gitsigns.select_hunk()
	end, "git: Select hunk")
end

---LSP keymaps, effective only where a server is attached.
local function lsp_maps(buf)
	local function m(lhs, fn, desc)
		vim.keymap.set("n", lhs, fn, { buffer = true, noremap = true, silent = true, desc = desc })
	end
	m("<leader>li", function() vim.lsp.buf.show_client_info() end, "lsp: Info")
	m("<leader>lr", function() vim.lsp.buf.restart() end, "lsp: Restart")
	m("gd", function() vim.lsp.buf.definition() end, "lsp: Goto definition")
	m("gD", function() vim.lsp.buf.declaration() end, "lsp: Goto declaration")
	m("gr", function() vim.lsp.buf.references() end, "lsp: References")
	m("gi", function() vim.lsp.buf.implementation() end, "lsp: Implementations")
	m("K", function() vim.lsp.buf.hover() end, "lsp: Show doc")
	m("gO", function() vim.lsp.buf.document_symbol() end, "lsp: Document outline")
	m("gs", function() vim.lsp.buf.signature_help() end, "lsp: Signature help")
	m("ga", function() vim.lsp.buf.code_action() end, "lsp: Code action for cursor")
	vim.keymap.set("v", "<leader>ca", function() vim.lsp.buf.select_code_action() end,
		{ buffer = true, noremap = true, silent = true, desc = "lsp: Code action for selection" })
end
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		lsp_maps(args.buf)
	end,
})

-- Apply user LSP keymap overrides (a function taking the buffer number).
local ok_lsp, user_lsp = pcall(require, "user.keymap.completion")
if ok_lsp and type(user_lsp) == "table" and type(user_lsp.lsp) == "function" then
	local extra = user_lsp.lsp(0)
	if type(extra) == "table" then
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				for key, rhs in pairs(extra) do
					local sep = key:find("|", 1, true)
					if sep then
						local mode = key:sub(1, sep - 1)
						local lhs = key:sub(sep + 1)
						if rhs == false or rhs == "" then
							vim.keymap.del(mode, lhs)
						else
							vim.keymap.set(mode, lhs, rhs, { buffer = true, noremap = true, silent = true })
						end
					end
				end
			end,
		})
	end
end

return M
