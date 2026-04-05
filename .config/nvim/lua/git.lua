-- git + vim 💕

local M = {}
local cmp = require('cmp') -- completion plugin
local diffview_configured = false

local function ensure_diffview()
  if vim.fn.exists(':DiffviewOpen') == 2 then
    if not diffview_configured then
      M.setup_diffview()
    end
    return true
  end

  pcall(vim.cmd, 'silent! packadd diffview.nvim')

  if vim.fn.exists(':DiffviewOpen') ~= 2 then
    return false
  end

  if not diffview_configured then
    M.setup_diffview()
    diffview_configured = true
  end

  return true
end

local function git_ref_exists(ref)
  vim.fn.system({ 'git', 'rev-parse', '--verify', ref })
  return vim.v.shell_error == 0
end

local function default_revision_range()
  local remote_head = vim.fn.systemlist({ 'git', 'symbolic-ref', '--quiet', 'refs/remotes/origin/HEAD' })[1]

  if vim.v.shell_error == 0 and remote_head and remote_head ~= '' then
    return remote_head:gsub('^refs/remotes/origin/', 'origin/') .. '...HEAD'
  end

  for _, ref in ipairs({ 'origin/main', 'origin/master', 'main', 'master' }) do
    if git_ref_exists(ref) then
      return ref .. '...HEAD'
    end
  end

  return 'HEAD~1...HEAD'
end

local function open_default_diff(opts)
  if not ensure_diffview() then
    vim.notify('Diffview is unavailable.', vim.log.levels.ERROR)
    return
  end

  local revision_range = opts.args ~= '' and opts.args or default_revision_range()
  vim.cmd('DiffviewOpen ' .. revision_range)
end

local function open_worktree_diff()
  if not ensure_diffview() then
    vim.notify('Diffview is unavailable.', vim.log.levels.ERROR)
    return
  end

  vim.cmd('DiffviewOpen')
end

local function open_current_file_history()
  if not ensure_diffview() then
    vim.notify('Diffview is unavailable.', vim.log.levels.ERROR)
    return
  end

  local current_file = vim.fn.expand('%')

  if current_file == '' then
    vim.notify('Open a file to inspect its git history.', vim.log.levels.WARN)
    return
  end

  vim.cmd('DiffviewFileHistory ' .. vim.fn.fnameescape(current_file))
end

local function open_repo_history()
  if not ensure_diffview() then
    vim.notify('Diffview is unavailable.', vim.log.levels.ERROR)
    return
  end

  vim.cmd('DiffviewFileHistory')
end

local function close_diffview()
  if not ensure_diffview() then
    return
  end

  vim.cmd('DiffviewClose')
end

function M.setup()
  -- set autocomplete for git commits
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  if vim.fn.has('nvim') == 1 then
    vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
  end

  vim.opt.diffopt:append({ 'algorithm:histogram', 'indent-heuristic', 'linematch:60' })

  vim.api.nvim_create_user_command('GitDiff', open_default_diff, { nargs = '?' })
  vim.api.nvim_create_user_command('GitDiffWorkingTree', open_worktree_diff, {})
  vim.api.nvim_create_user_command('GitDiffFileHistory', open_current_file_history, {})
  vim.api.nvim_create_user_command('GitDiffHistory', open_repo_history, {})
  vim.api.nvim_create_user_command('GitDiffClose', close_diffview, {})

  vim.keymap.set('n', '<leader>gd', '<cmd>GitDiff<cr>', { desc = 'Git diff against default branch', noremap = true, silent = true })
  vim.keymap.set('n', '<leader>gD', '<cmd>GitDiffWorkingTree<cr>', { desc = 'Git working tree diff', noremap = true, silent = true })
  vim.keymap.set('n', '<leader>gf', '<cmd>GitDiffFileHistory<cr>', { desc = 'Git file history', noremap = true, silent = true })
  vim.keymap.set('n', '<leader>gh', '<cmd>GitDiffHistory<cr>', { desc = 'Git repository history', noremap = true, silent = true })
  vim.keymap.set('n', '<leader>gq', '<cmd>GitDiffClose<cr>', { desc = 'Close git diff view', noremap = true, silent = true })
end

function M.setup_diffview()
  if diffview_configured then
    return
  end

  local ok, diffview = pcall(require, 'diffview')
  if not ok then
    return
  end

  diffview.setup({
    enhanced_diff_hl = true,
    use_icons = true,
    icons = {
      folder_closed = '',
      folder_open = '',
    },
    file_panel = {
      listing_style = 'tree',
      win_config = {
        position = 'left',
        width = 40,
      },
    },
    default_args = {
      DiffviewOpen = { '--imply-local' },
      DiffviewFileHistory = { '--base=LOCAL' },
    },
  })

  diffview_configured = true
end

return M
