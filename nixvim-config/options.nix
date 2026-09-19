# Port of lua/options.lua (the `vim.opt` table).
# The old conda `python3_host_prog` provider logic is dropped: nixvim's
# `withPython3` (on by default) supplies the Python provider from the Nix
# environment, which is the declarative equivalent.
{
  options = {
    # General
    autoread = true;
    backspace = "indent,eol,start";
    backup = false;
    # Break after these characters. Old value carried literal backslashes.
    breakat = "\\ \t;:,!?@*-+/";
    cmdheight = 1;
    cmdwinheight = 5;
    completeopt = "menuone,noselect";
    cursorline = true;
    diffopt = "filler,iwhite,internal,linematch:60,algorithm:patience";
    display = "lastline";
    fileencodings = "ucs-bom,utf-8,default,big5,latin1";
    fileformats = "unix,mac,dos";
    grepformat = "%f:%l:%c:%m";
    grepprg = "rg --hidden --vimgrep --smart-case --";
    hidden = true;
    history = 1000;
    ignorecase = true;
    inccommand = "nosplit";
    incsearch = true;
    infercase = true;
    jumpoptions = "stack,view";
    laststatus = 3;
    list = true;
    listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←";
    mousescroll = "ver:3,hor:6";
    number = true;
    relativenumber = true;
    scrolloff = 3;
    sessionoptions = "buffers,curdir,folds,help,tabpages,winpos,winsize";
    shiftwidth = 4;
    shortmess = "aoOTIcF";
    showbreak = "↳  ";
    showcmd = false;
    showmode = false;
    showtabline = 2;
    sidescrolloff = 5;
    smartcase = true;
    splitbelow = true;
    splitright = true;
    swapfile = false;
    termguicolors = true;
    timeout = true;
    timeoutlen = 300;
    ttimeout = true;
    ttimeoutlen = 0;
    updatetime = 200;
    undofile = true;
    undolevels = 10000;
    whichwrap = "h,l,<,>,[,],~";
    wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**";
    wildignorecase = true;
    winminwidth = 10;
    winwidth = 30;
    wrapscan = true;
    writebackup = true;

    # Per-buffer (set as the startup local values, matching the old bw-local set)
    autoindent = true;
    concealcursor = "niv";
    conceallevel = 0;
    expandtab = true;
    formatoptions = "croql";
    linebreak = true;
    signcolumn = "yes";
    softtabstop = 4;
    tabstop = 4;
  };
}
