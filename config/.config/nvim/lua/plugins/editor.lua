---@diagnostic disable: missing-fields

local signs = require("utils.signs")

local disable_filetypes = {
  "NvimTree",
  "dashboard",
  "DiffviewFiles",
  "DressingInput",
  "DressingSelect",
  "TelescopePrompt",
  "lazy",
  "mason",
}

return {
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    opts = {
      config = {
        disable_move = true,
        header = signs.dashboard,
        project = {
          enable = false,
        },
        mru = { limit = 5 },
        shortcut = {
          { desc = "Find files", key = "f", action = "Telescope find_files" },
          {
            desc = "Load current session",
            key = "s",
            action = function()
              local ok = pcall(require("persistence").load)
              if ok then
                vim.notify("Last sessions loaded")
              else
                vim.notify("Error when loading the last session")
              end
            end,
          },
          { desc = "Lazy", key = "l", action = "Lazy" },
          { desc = "Mason", key = "m", action = "Mason" },
          { desc = "Quit", key = "q", action = "quit" },
        },
      },
    },
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
    },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<C-g>", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<C-n>", "<cmd>Telescope grep_string<cr>", desc = "Grep current word" },
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to definition" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Go to implementations" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Go to references" },
      { "gD", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Go to type definitions" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "List git branches" },
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      local trouble = require("trouble.sources.telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = { ["<c-q>"] = trouble.open },
            n = { ["<c-q>"] = trouble.open },
          },
          file_ignore_patterns = { "^.git/" },
          vimgrep_arguments = {
            "rg",
            "--trim",
            "--color=never",
            "--vimgrep",
            "--smart-case",
            "--hidden",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "V",
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>j"] = "@function.outer",
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>k"] = "@function.outer",
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "markdown",
      "typescript",
      "typescriptreact",
      "xml",
      "html",
    },
    opts = {},
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "sass", "scss", "html" },
    opts = { "css", "sass", "scss", "html" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown" },
    opts = {},
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      auto_close = true,
      signs = {
        error = signs.diagnostics.Error,
        warning = signs.diagnostics.Warn,
        hint = signs.diagnostics.Hint,
        information = signs.diagnostics.Info,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle trouble" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Loclist" },
    },
    cmd = "Trouble",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.setup({
        fast_wrap = {},
        disable_filetype = disable_filetypes,
      })

      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        Rule(" ", " ")
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
              brackets[1][1] .. "  " .. brackets[1][2],
              brackets[2][1] .. "  " .. brackets[2][2],
              brackets[3][1] .. "  " .. brackets[3][2],
            }, context)
          end),
      })
      for _, bracket in pairs(brackets) do
        Rule("", " " .. bracket[2])
          :with_pair(cond.none())
          :with_move(function(opts)
            return opts.char == bracket[2]
          end)
          :with_cr(cond.none())
          :with_del(cond.none())
          :use_key(bracket[2])
      end
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = "Refactor",
    keys = {
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor({
            show_success_message = true,
          })
        end,
        mode = { "n", "x" },
        desc = "Select refactor",
      },
    },
    opts = {},
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        filetypes_denylist = disable_filetypes,
      })
    end,
  },
  {
    "Wansmer/treesj",
    keys = {
      { "<space>m", desc = "Toggle splitjoin" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "lspinfo",
          "checkhealth",
          "help",
          "man",
          "gitcommit",
          unpack(disable_filetypes),
        },
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        insert_only = false,
      },
    },
    event = "VeryLazy",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>g", group = "git" },
        { "<leader>x", group = "trouble" },
        { "<leader>d", group = "debugger" },
        { "<leader>t", group = "test" },
        { "<leader>w", group = "workspace" },
        { "<leader>r", group = "refactor" },
        { "<leader>h", group = "hunk" },
        { "<leader>c", group = "code" },
      })
    end,
    init = function()
      vim.opt.timeout = true
      vim.opt.timeoutlen = 500
    end,
  },
}
