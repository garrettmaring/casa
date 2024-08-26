-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'     -- Packer can manage itself
  use 'Soares/base16.nvim'
  use 'famiu/nvim-reload'          -- easy reloading  after editing vim configuration
  use "b0o/mapx.nvim"              -- easier mapping settings
  use "edluffy/hologram.nvim"      -- image previewing
  use 'sainnhe/edge'               -- edge dark theme
  use 'drybalka/tree-climber.nvim' -- navigate around highlighting
  use 'lewis6991/spellsitter.nvim' -- spell checker
  use 'andymass/vim-matchup'       -- block/bracket-wise movement
  use "svermeulen/vim-cutlass"     -- override vim's default cut (`dd` in Normal, etc.) behavior
  use "svermeulen/vim-subversive"  -- substitues with text objects
  use "windwp/nvim-autopairs"      -- open/closing brackets, parentheses, braces etc.
  use { 'romgrk/fzy-lua-native', run = 'make' }
  use "nathom/filetype.nvim"       -- faster startup
  use "triglav/vim-visual-increment"
  use { 'tpope/vim-dispatch', opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'preservim/nerdcommenter'            -- commenting commenting
  use 'mfussenegger/nvim-dap'              -- debugger, breakpoints, step-through
  use 'simrat39/rust-tools.nvim'           -- Rust debugging
  use 'edluffy/specs.nvim'                 -- animate cursor when moving
  use 'kyazdani42/nvim-web-devicons'       -- nicer icons for file trees, diagnostic lists, etc.
  use 'jose-elias-alvarez/typescript.nvim' -- typescript
  use 'junegunn/goyo.vim'                  -- writing in vim
  use 'bfredl/nvim-ipy'
  use 'simrat39/symbols-outline.nvim'      -- symbol viewer
  use 'mhinz/vim-startify'                 -- cool vim startup screen
  use 'merrickluo/lsp-tailwindcss'         -- tailwind completion and rule preview
  -- use 'yaegassy/coc-tailwindcss3' -- tailwind completion and rule preview

  -- easy motion (vimium style navigation)
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- use 'JoosepAlviste/nvim-ts-context-commentstring' -- improve commenting in multi-langugage files (CSS-in-JS). is this working?

  -- TODO: linting with ale?
  --use {
  --'w0rp/ale',
  --ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
  --cmd = 'ALEEnable',
  --config = 'vim.cmd[[ALEEnable]]'
  --}

  use_rocks 'penlight'                                                                            -- helpful Lua functions for common programming patterns
  use_rocks 'lua-resty-http'                                                                      -- Lua http helpers
  use_rocks 'lpeg'                                                                                -- Lua regex helpers

  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' } -- preview markdown files in a browser page

  -- run our vim in the browser
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  use 'folke/trouble.nvim' -- show diagnostics (pretty 💅)

  -- add git to buffer, statusline, etc.
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end
  }

  use 'tjdevries/colorbuddy.vim'

  -- kitty navigation integration
  --use {'knubie/vim-kitty-navigator', run = 'cp ./*.py ~/.config/kitty/' }
  use { 'knubie/vim-kitty-navigator' }

  -- file tree
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require 'nvim-tree'.setup {
        view = {
          side = "right"
        },
        renderer = {
          icons = {
            show = {
              folder_arrow = false
            }
          }
        }
      }
    end
  }

  use {
    "antosha417/nvim-lsp-file-operations",
    requires = {
      "nvim-lua/plenary.nvim",
      --"nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  }

  use 'romgrk/barbar.nvim' -- a great buffer tab bar

  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require 'lualine'.setup {
        options = {
          theme = 'edge'
        },
      }
    end
  }

  -- syntax highlighting, refactoring
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'nvim-treesitter'.setup {
        ensure_installed = "all",

        hightlight = {
          enable = true
        },

        indent = {
          enable = true
        },

        rainbow = {
          enable = true,
          extended_mode = true, -- html tags
          max_file_lines = nil
        },

        context_commentstrind = {
          enable = true
        }
      }
    end
  }

  use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    }
  }

  -- searching
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- faster searching

  use "SmiteshP/nvim-navic"                                        -- show language specific context in status line
  use 'lewis6991/nvim-treesitter-context'                          -- show context in winbar (ie within function or struct)

  -- language servers for syntax, autocomplete, status line, etc.
  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig'
  }

  use({
    "hrsh7th/nvim-cmp", -- use for automcompletion engine
    requires = {
      {
        "KadoBOT/cmp-plugins",
        config = function()
          require("cmp-plugins").setup({
            files = { ".*\\.lua" } -- default
          })
        end,
      },
    }
  })
  use "hrsh7th/cmp-nvim-lsp"                                              -- use to provide the LSP source to autocomplete (cmp)
  use "hrsh7th/cmp-path"                                                  -- use to autocomplete file & directory paths
  use "hrsh7th/cmp-calc"                                                  -- use to evaluate/autocomplete mathematical expressions
  use { 'tzachar/cmp-fuzzy-buffer', requires = { 'tzachar/fuzzy.nvim' } } -- use for better fuzzy buffer autocompletion
  -- use to add snippets source to autocomplete via LuaSnip
  use {
    "saadparwaiz1/cmp_luasnip",
    requires = "L3MON4D3/LuaSnip"
  }
  -- use to add more snippets to LuaSnip
  use { "rafamadriz/friendly-snippets" }
  -- git commit completion
  use 'petertriho/cmp-git'
  use 'hrsh7th/cmp-nvim-lsp-signature-help' -- use to automcomplete better function signatures


  --use { 'sourcegraph/sg.nvim', run = 'nvim -l build/init.lua' }

  -- use to add Rust/Cargo crates source to autocomplet
  use {
    'saecki/crates.nvim',
    config = function()
      require('crates').setup()
    end,
  }

  use {
    'David-Kunz/cmp-npm',
    config = function()
      require('cmp-npm').setup()
    end,
  }

  -- visualize registers & their content
  use {
    "tversteeg/registers.nvim",
    config = function()
      -- FIX: this errors on packer sync
      --require("registers").setup()
    end,
  }

  use {
    'yetone/avante.nvim',
    --event = 'BufRead', -- Use a valid event like 'BufRead' for lazy loading
    --build = 'make',    -- Optional build step
    config = function()
      -- see copilot.lua for config
    end,
    requires = {
      --'nvim-tree/nvim-web-devicons', -- installed elsewhere
      --'nvim-lua/plenary.nvim', -- installed elsewhere
      'stevearc/dressing.nvim',
      'MunifTanjim/nui.nvim',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'Avante' }, -- Lazy load based on file type
        config = function()
          require('render-markdown').setup({
            file_types = { 'markdown', 'Avante' },
          })
        end,
      },
    },
  }

  -- ai code completion with avant
  --
  -- ai code completion with copilot
  --use "github/copilot.vim"
  --use {
  --"Exafunction/codeium.nvim",
  --requires = {
  --"nvim-lua/plenary.nvim",
  --"hrsh7th/nvim-cmp",
  --},
  --config = function()
  --require("codeium").setup({})
  ----vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
  ----vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
  ----vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
  ----vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  --end
  --}
end)
