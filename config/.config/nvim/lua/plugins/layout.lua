local icons = require("utils.signs")

return {
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<c-s>", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toogle explorer" },
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toogle explorer" },
    },
    cmd = { "NvimTreeFindFileToggle" },
    dependencies = "nvim-tree/nvim-web-devicons",
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = true,
      select_prompts = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        icons = {
          hint = icons.diagnostics.Hint,
          info = icons.diagnostics.Info,
          warning = icons.diagnostics.Warn,
          error = icons.diagnostics.Error,
        },
      },
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      git = {
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      sort_by = "case_sensitive",
      reload_on_bufenter = true,
      view = {
        adaptive_size = true,
        centralize_selection = true,
        number = true,
        relativenumber = true,
      },
      renderer = {
        group_empty = true,
        root_folder_label = false,
        indent_markers = {
          enable = true,
        },
      },
      filters = {
        dotfiles = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = { "node_modules", ".git", "build", "dist" },
      },
    },
  },
  {
    "utilyre/barbecue.nvim",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(res)
              return res:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = icons.diagnostics.Error .. " ",
              warn = icons.diagnostics.Warn .. " ",
              info = icons.diagnostics.Info .. " ",
              hint = icons.diagnostics.Hint .. " ",
            },
          },
        },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = {
        "nvim-tree",
        "quickfix",
        "mason",
        "lazy",
        "man",
        "trouble",
        {
          sections = {
            lualine_a = { "filetype" },
          },
          filetypes = {
            "TelescopePrompt",
            "DressingInput",
          },
        },
        {
          sections = {
            lualine_a = { "filetype" },
            lualine_b = { "branch" },
          },
          filetypes = {
            "NeogitStatus",
            "NeogitPopup",
            "NeogitLogView",
            "NeogitCommitView",
            "DiffviewFiles",
            "DiffviewFileHistory",
          },
        },
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    config = function()
      local scrollbar = require("scrollbar")
      local colors = require("tokyonight.colors").setup()

      scrollbar.setup({
        handle = {
          color = colors.fg_gutter,
        },
        marks = {
          Search = { color = colors.orange },
          Error = { color = colors.error },
          Warn = { color = colors.warning },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          Misc = { color = colors.purple },
        },
        handlers = {
          cursor = false,
        },
        excluded_filetypes = {
          "dropbar_menu",
          "dropbar_menu_fzf",
          "DressingInput",
          "cmp_docs",
          "cmp_menu",
          "noice",
          "prompt",
          "TelescopePrompt",
          "lazy",
          "mason",
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      options = {
        mode = "tabs",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
          {
            filetype = "DiffviewFiles",
            text = "Source control",
            text_align = "center",
            separator = true,
          },
        },
      },
    },
  },
  {

    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
  },
}
