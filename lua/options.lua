-- Vim options. Override in lua/user/options.lua if you keep that layer.

local M = {}

function M.load()
	local options = {
		autoread = true,
		backspace = "indent,eol,start",
		backup = false,
		breakat = [[\ \	;:,!?@*-+/]],
		clipboard = "unnamedplus",
		cmdheight = 1,
		cmdwinheight = 5,
		completeopt = "menuone,noselect",
		cursorline = true,
		diffopt = "filler,iwhite,internal,linematch:60,algorithm:patience",
		display = "lastline",
		fileencodings = "ucs-bom,utf-8,default,big5,latin1",
		fileformats = "unix,mac,dos",
		grepformat = "%f:%l:%c:%m",
		grepprg = "rg --hidden --vimgrep --smart-case --",
		hidden = true,
		history = 1000,
		ignorecase = true,
		inccommand = "nosplit",
		incsearch = true,
		infercase = true,
		jumpoptions = "stack,view",
		laststatus = 3,
		list = true,
		listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
		mousescroll = "ver:3,hor:6",
		number = true,
		relativenumber = true,
		scrolloff = 3,
		sessionoptions = "buffers,curdir,folds,help,tabpages,winpos,winsize",
		shiftwidth = 4,
		shortmess = "aoOTIcF",
		showbreak = "↳  ",
		showcmd = false,
		showmode = false,
		showtabline = 2,
		sidescrolloff = 5,
		smartcase = true,
		splitbelow = true,
		splitright = true,
		swapfile = false,
		termguicolors = true,
		timeout = true,
		timeoutlen = 300,
		ttimeout = true,
		ttimeoutlen = 0,
		updatetime = 200,
		undofile = true,
		undolevels = 10000,
		whichwrap = "h,l,<,>,[,],~",
		wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**",
		wildignorecase = true,
		winminwidth = 10,
		winwidth = 30,
		wrapscan = true,
		writebackup = true,
		-- bw local
		autoindent = true,
		concealcursor = "niv",
		conceallevel = 0,
		expandtab = true,
		formatoptions = "croql",
		linebreak = true,
		signcolumn = "yes",
		softtabstop = 4,
		tabstop = 4,
	}
	for name, value in pairs(options) do
		vim.api.nvim_set_option_value(name, value, {})
	end

	-- Custom python provider
	local conda_prefix = vim.env.CONDA_PREFIX
	local function isempty(s)
		return s == nil or s == ""
	end
	if not isempty(conda_prefix) then
		vim.g.python3_host_prog = vim.g.python3_host_prog or conda_prefix .. "/bin/python"
	else
		vim.g.python3_host_prog = vim.g.python3_host_prog or "python3"
	end
end

return M
