vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "14.2")


require('packer.luarocks').install_commands()
require("load_env")
require("colors")
require('providers')      -- neovim python providers
require('maps')           -- keybindings
require('statusline')     -- custom statusline
require('plugins')        -- packer plugins
require('lsp')            -- language servers
require('autocomplete')   -- completion
require('snippets')       -- snippet settings
require('search')         -- searching
require('filestypes')     -- faster/customer file type
require('mail')           -- email
require('filetree')       -- file tree settings
require('registers')      -- copy pasta 🍝
require('hints')          -- easy motion
require('commenting')     -- nerdcommenter settings
require('git')            -- totally Torvalds
require('gitsigns')       -- gitsigns plugin configuration
require('rust')           -- configure Rust debugger
require('cursor')         -- customize the cursor
require('diagnostics')    -- diagnostics settings
require('tabs')           -- buffers & tab viewing
require('splits')         -- lickity-split splits
require('_refactoring')   -- easy robust refactoring
require('replace')        -- replacing seleted text (outside refactoring)
require('media')          -- images, videos, audio
require('symbols')
require("metamanagement") -- specifics for working on the workbench
require('settings')       -- misc settings
require('alfred')         -- there's nothing i don't
require('syntax_highlighting')
require('ai')
require('panes')
require('clipboard')
require('folds')
require('highlights')
require('editing')
require('winbar')
require('buffers')
