return {
  {
    -- snacks.vim is a prereq for heaps of others, so it
    -- probably wants to be near the top of the list
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = {
          enabled = true,
          notify = true,
        },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = {
          enabled = true,
          animate = {
            enabled = false,
            duration = {
              step = 5,    -- step duration in ms
              total = 100, -- max duration in ms
            },
          },
        },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
	--scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
      },
    },
    "tpope/vim-surround",
    "tpope/vim-repeat",

    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      branch = 'master',
      build = ':TSUpdate',
      config = function () 
        local configs = require("nvim-treesitter.configs")
        configs.setup({
          ensure_installed = {
            "bash",
            "c",
            "cmake",
            "cpp",
            "css",
            "diff",
            "gitignore",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "graphql",
            "http",
            "java",
            "ini",
            "hcl",
            "json",
            "jsonc",
            "kotlin",
            "objc",
            "swift",
            "twig",
            "php",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
            "ruby",
            "puppet",
            "terraform",
            "ninja",
            "markdown",
            "sql",
            "markdown_inline",
            "regex",
            "make",
            "dockerfile",
            "xml",
            "luadoc",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "elixir",
            "heex",
            "javascript",
            "html",
          },
          auto_install = true,
          sync_install = false,
          highlight = { enable = true },
        })
      end
    },

    {
      "mason-org/mason.nvim",
      opts = {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      }
    },

    'neovim/nvim-lspconfig',

    "chrisbra/unicode.vim",
    "github/copilot.vim",
  }
}

