# Port of lua/options.lua (the `vim.opt` table).
#
# The old conda `python3_host_prog` provider logic is dropped. nixvim's
# `withPython3` (on by default) supplies the Python provider from the Nix
# environment, which is the declarative equivalent.
#
# Nixvim's user-facing key for `vim.opt.*` is `opts` (see its modules/opts.nix,
# `luaApi = "opt"`, emitted as `vim.opt`). The sibling keys are `globalOpts`,
# `localOpts`, and `globals`. The name `options` is NOT a declared nixvim
# option, so the module system silently drops it. That is why this table used
# to be lost and the line-number column vanished.
#
# All of these are set globally (matching the old `nvim_set_option_value`
# calls with an empty scope). They apply to every buffer, and new buffers
# inherit the global values.
{
  opts = {
    # General
    autoread = true;
    autowrite = true;
    backspace = "indent,eol,start";
    backup = false;
    # Break after these characters. Old value carried literal backslashes.
    breakat = "\\ \t;:,!?@*-+/";
    cmdheight = 1;
    cmdwinheight = 5;
    complete = ".,w,b,k,kspell";
    completeopt = "fuzzy,menuone,noselect,popup";
    cursorcolumn = true;
    cursorline = true;
    diffopt = "filler,iwhite,internal,linematch:60,algorithm:patience";
    display = "lastline";
    encoding = "utf-8";
    equalalways = false;
    errorbells = true;
    fileencodings = "ucs-bom,utf-8,default,big5,latin1";
    fileformats = "unix,mac,dos";
    foldlevelstart = 99;
    grepformat = "%f:%l:%c:%m";
    grepprg = "rg --hidden --vimgrep --smart-case --";
    helpheight = 12;
    hidden = true;
    history = 2000;
    ignorecase = true;
    inccommand = "nosplit";
    incsearch = true;
    infercase = true;
    jumpoptions = "stack,view";
    laststatus = 3;
    list = true;
    listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←";
    magic = true;
    mousescroll = "ver:3,hor:6";
    number = true;
    previewheight = 12;
    pumblend = 0;
    pumheight = 15;
    redrawtime = 1500;
    relativenumber = true;
    ruler = true;
    scrolloff = 3;
    sessionoptions = "buffers,curdir,folds,help,tabpages,winpos,winsize";
    shada = "!,'500,<50,@100,s10,h";
    shiftround = true;
    shiftwidth = 4;
    shortmess = "aoOTIcF";
    showbreak = "↳  ";
    showcmd = false;
    showmode = false;
    showtabline = 2;
    sidescrolloff = 5;
    smartcase = true;
    smarttab = true;
    # `smoothscroll` is still a valid option in this Neovim build (verified via
    # `nvim_get_option_info`). It matches the old config's `smoothscroll = true`.
    smoothscroll = true;
    splitbelow = true;
    splitkeep = "screen";
    splitright = true;
    startofline = false;
    swapfile = false;
    switchbuf = "usetab,uselast";
    termguicolors = true;
    timeout = true;
    timeoutlen = 300;
    ttimeout = true;
    ttimeoutlen = 0;
    updatetime = 200;
    undofile = true;
    undolevels = 10000;
    viewoptions = "folds,cursor,curdir,slash,unix";
    virtualedit = "block";
    visualbell = true;
    whichwrap = "h,l,<,>,[,],~";
    wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**";
    wildignorecase = true;
    winblend = 0;
    winminwidth = 10;
    winwidth = 30;
    wrapscan = true;
    writebackup = true;

    # Per-buffer (set globally, matching the old bw-local set)
    autoindent = true;
    breakindentopt = "shift:2,min:20";
    concealcursor = "niv";
    conceallevel = 0;
    expandtab = true;
    foldenable = true;
    formatoptions = "1jcroql";
    linebreak = true;
    signcolumn = "yes";
    softtabstop = 4;
    synmaxcol = 2500;
    tabstop = 4;
    textwidth = 80;
    wrap = false;
  };
}
