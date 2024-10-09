--[[
    For how Neovim integrates run :help lua-guide
    We provide a keymap "<space>sh" to [s]earch the [h]elp documentation
    If you experience any errors while trying to install kickstart, run `:checkhealth` for more info
    To check the current status of your plugins, run :Lazy
    To update plugins you can run :Lazy update
    {opts={}} is equivalent to the following Lua: require('gitsigns').setup({ ... })
    Use `opts = {}` to force a plugin to be loaded.
    Plugins can also be configured to run Lua code when they are loaded. This is often very useful to both group configuration, as well as handle lazy loading plugins that don't need to be loaded immediately at startup.
    Then, because we use the `config` key, the configuration only runs after the plugin has been loaded: config = function() ... end
    The dependencies are proper plugin specifications as well - anything you do for a plugin at the top level, you can do for a dependency. Use the `dependencies` key to specify the dependencies of a particular plugin
    Two important keymaps to use while in Telescope are: Insert mode: <c>.  Normal mode: ?
    See `:help telescope` and `:help telescope.setup()`
--]]

vim.g.mapleader = ' ' -- Set <space> as the leader key
vim.g.maplocalleader = ' ' -- Set <space> as the leader key
vim.g.have_nerd_font = true -- To enable nerdfont if you have it installed

-- NOTE: Setting Options
vim.opt.number = true -- Make line numbers default
vim.opt.relativenumber = true -- Make line numbers relative
vim.opt.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.signcolumn = 'yes' -- Keep signcolumn on by default
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time, displays which-key popup sooner
vim.opt.splitright = true -- Split to the right when splitting vertically
vim.opt.splitbelow = true -- Split below when splitting horizontally
vim.opt.list = true -- Sets how neovim will display certain whitespace characters in the editor
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Sets how neovim will display certain whitespace characters in the editor
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor
vim.opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.

-- NOTE: Basic Keymaps
vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<CR>') -- Clear highlights on search when pressing <C-c> in normal mode
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' }) -- Diagnostic keymaps
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' }) -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move you noob!"<CR>') -- Disable arrow keys in normal mode
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!"<CR>') -- Disable arrow keys in normal mode
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!"<CR>') -- Disable arrow keys in normal mode
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!"<CR>') -- Disable arrow keys in normal mode
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line up' }) -- Use alt + j to move lines down
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line down' }) -- Use alt + k to move lines up
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move lines up' }) -- Use alt + j to move lines down in visual mode
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move lines down' }) -- Use alt + k to move lines up in visual mode
vim.keymap.set({ 'n', 'v' }, '<C-j>', '5j', { desc = 'Move 5 lines down' })
vim.keymap.set({ 'n', 'v' }, '<C-k>', '5k', { desc = 'Move 5 lines up' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' }) -- Go to previous diagnostic message
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' }) -- Go to next diagnostic message
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' }) -- Open error messages
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' }) -- Open diagnostic quickfix
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save' }) -- Save description
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', 'f', ':HopWord<CR>', { desc = 'Hop to any word' })
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

-- NOTE: Basic Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- NOTE: Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Configure and install plugins
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Adds hopping to a word
    'smoka7/hop.nvim',
    tag = '*',
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
    end,
  },

  { -- Adds Lazygit within Neovim
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  { -- Adds a quick explorer
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      vim.keymap.set('n', '<leader>aa', function()
        harpoon:list():add()
      end, { desc = '[A]dd' })
      vim.keymap.set('n', '<leader>ad', function()
        harpoon:list():remove()
      end, { desc = '[D]elete' })
      vim.keymap.set('n', '<C-A-h>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<C-A-j>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<C-A-k>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<C-A-l>', function()
        harpoon:list():select(4)
      end)
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<C-l>', function()
        harpoon:list():next()
      end)

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },

  { -- Plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      spec = { -- Document existing key chains
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>a', group = 'H[a]rpoon' },
      },
    },
  },

  -- NOTE: Telescope
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- NOTE: LSP Plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  { -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
      'Hoffs/omnisharp-extended-lsp.nvim',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', { -- This function gets run when an LSP attaches to a particular buffer
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode) -- Sets the mode, buffer and description for us each time
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == 'omnisharp' then
            map('gd', ":lua require('omnisharp_extended').lsp_definition()<cr>", '[G]oto [D]efinition Omnisharp')
            map('gr', ":lua require('omnisharp_extended').telescope_lsp_references()<cr>", '[G]oto [R]eferences Omnisharp')
          else
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition') -- To jump back, press <C-t>
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences') -- Find references for the word under your cursor
          end

          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation') -- Jump to the implementation of the word under your cursor
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition') -- Jump to the type of the word under your cursor
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols') -- Fuzzy find all the symbols in your current document
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols') -- Fuzzy find all the symbols in your current workspace
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame') -- Rename the variable under your cursor
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' }) -- Execute a code action, usually your cursor needs to be on top of an error or a suggestion
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration') -- This is not Goto Definition, this is Goto Declaration

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then -- Toggle inlay hints in your code
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      local servers = {
        pyright = {},
        omnisharp = {},
        jsonls = {},
        ts_ls = {},
        -- lua_ls = {
        --   settings = {
        --     Lua = {
        --       completion = {
        --         callSnippet = 'Replace',
        --       },
        --     },
        --   },
        -- },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { -- You can add other tools here that you want Mason to install for you, so that they are available from within Neovim
        'stylua',
        'csharpier',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        omnisharp = { 'csharpier' },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'carbonfox'
      vim.cmd.hi 'Comment gui=none' -- Removes any GUI styling (like italics or bold) from comments
    end,
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } }, -- Highlight todo, notes, etc in comments

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  -- 'nvim-treesitter/nvim-treesitter-context',

  -- NOTE: Add/Configure additional plugins
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns',
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.lint',

  { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
