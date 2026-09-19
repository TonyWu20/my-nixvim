# Custom Lua that no nixvim plugin module can express: the search.nvim tabbed
# UX and the setup calls for the `extraPlugins` that have no nixvim module.
# Each block is pcall-guarded so a missing/renamed plugin degrades instead of
# crashing startup.
#
# `extraConfigLuaPost` is a single string (types.lines), so all blocks are
# concatenated into one literal. Lua `#` is the length operator, so section
# headers use Lua `--` comments, not Nix `#`.
{
  extraConfigLuaPost = ''
    -- ---- search.nvim: tabbed ff/fp collections (confirmed Option A) ----
    pcall(function()
      local extensions = require('telescope').extensions
      local builtins = require('telescope.builtin')
      pcall(require('telescope').load_extension, 'frecency')
      pcall(require('telescope').load_extension, 'live_grep_args')
      local prompt_pos = require('telescope.config').values.layout_config.horizontal.prompt_position
      local collections = {
        file = {
          initial_tab = 1,
          tabs = {
            { 'Files', builtins.find_files },
            { 'Frecency', function() extensions.frecency.frecency() end },
            { 'Buffers', builtins.buffers },
          },
        },
        pattern = {
          initial_tab = 1,
          tabs = {
            { 'Word in project', extensions.live_grep_args.live_grep_args },
            { 'Word under cursor', builtins.grep_string },
          },
        },
      }
      require('search').setup({ prompt_position = prompt_pos, collections = collections })
    end)

    -- ---- smartyank.nvim: auto-copy on yank ----
    pcall(function()
      require('smartyank').setup({
        highlight = { enabled = false },
        clipboard = { enabled = true },
        tmux = { enabled = true, cmd = { 'tmux', 'set-buffer', '-w' } },
        osc52 = { enabled = true, ssh_only = true, silent = true },
        validate_yank = false,
      })
    end)

    -- ---- focus.nvim: auto-resize split to focus buffer ----
    pcall(function()
      require('focus').setup({
        enable = true,
        commands = true,
        autoresize = {
          enable = true, width = 0, height = 0, minwidth = 0, minheight = 0,
          height_quickfix = 10,
        },
        split = { bufnew = false, tmux = false },
        ui = {
          number = false, relativenumber = false, hybridnumber = false,
          absolutenumber_unfocussed = false, cursorline = true,
          cursorcolumn = false, colorcolumn = { enable = false, list = '+1' },
          signcolumn = true, winhighlight = false,
        },
      })
    end)

    -- ---- im-select.nvim: CJK IME switching (no-op if the plugin is absent) ----
    pcall(function()
      require('im-select').setup({
        default_im_select = 'keyboard-us',
        default_command = 'fcitx5-remote',
      })
    end)

    -- ---- lean.nvim: Lean4 language support ----
    pcall(function()
      require('lean').setup({ mappings = true })
    end)

    -- ---- mini.surround: surround operators ----
    pcall(function()
      require('mini.surround').setup()
    end)
  '';
}
