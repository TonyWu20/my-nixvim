{ lib, ... }:
let
  nlua = lib.nixvim.mkRaw;
in
{
  plugins.gitsigns = {
    enable = true;
    lazyLoad.settings.event = [
      "CursorHold"
      "CursorHoldI"
    ];
    settings.auto_attach = true;
    settings.current_line_blame = true;
    settings.signs = {
      add = {
        text = "┃";
      };
      change = {
        text = "┃";
      };
      delete = {
        text = "_";
      };
      topdelete = {
        text = "‾";
      };
      changedelete = {
        text = "~";
      };
      untracked = {
        text = "┆";
      };
    };
    # Buffer-scoped hunk maps (port of the old keymaps.lua M.gitsigns).
    settings.on_attach = nlua ''
      function(bufnr)
        local gitsigns = require('gitsigns')
        local function bmap(mode, lhs, fn, desc, expr)
          local o = { noremap = true, buffer = true, desc = desc }
          if expr then o.expr = true end
          vim.keymap.set(mode, lhs, fn, o)
        end
        bmap('n', ']g', function()
          if vim.wo.diff then return ']g' end
          vim.schedule(function() gitsigns.nav_hunk('next') end)
          return '<Ignore>'
        end, 'git: Goto next hunk', true)
        bmap('n', '[g', function()
          if vim.wo.diff then return '[g' end
          vim.schedule(function() gitsigns.nav_hunk('prev') end)
          return '<Ignore>'
        end, 'git: Goto prev hunk', true)
        bmap('n', '<leader>gs', function() gitsigns.stage_hunk() end, 'git: Toggle hunk')
        bmap('v', '<leader>gs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'git: Toggle hunk')
        bmap('n', '<leader>gr', function() gitsigns.reset_hunk() end, 'git: Reset hunk')
        bmap('v', '<leader>gr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'git: Reset hunk')
        bmap('n', '<leader>gR', function() gitsigns.reset_buffer() end, 'git: Reset buffer')
        bmap('n', '<leader>gp', function() gitsigns.preview_hunk() end, 'git: Preview hunk')
        bmap('n', '<leader>gb', function() gitsigns.blame_line({ full = true }) end, 'git: Blame line')
        bmap('o', 'ih', function() gitsigns.select_hunk() end, 'git: Select hunk')
        bmap('x', 'ih', function() gitsigns.select_hunk() end, 'git: Select hunk')
      end
    '';
  };
}
