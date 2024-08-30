local icons = require("utils.signs")
local map = require("utils.map")

return {
  {
    "neovim/nvim-lspconfig",
    event = { "VeryLazy" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
      { "folke/neodev.nvim", opts = {} },
      { "folke/neoconf.nvim", opts = {} },
    },
    config = function()
      map("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto next diagnostic" })
      map("n", "]d", vim.diagnostic.goto_next, { desc = "Goto previous diagnostic" })
      map("n", "<space>q", vim.diagnostic.setloclist, { desc = "Open loclist with diagnostics" })

      for name, icon in pairs(icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        -- stylua: ignore
        callback = function(ev)
          -- Mappings.
          map("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf,  desc = "Go to type definition" })
          map("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = "Add workspace folder" })
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = "Remove workspace folder" })
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { buffer = ev.buf, desc = "List workspace folders" })
          map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code actions" })
        end,
      })

      local lspconfig = require("lspconfig")
      local servers = {
        "lua_ls",
        "bashls",
        {
          "ts_ls",
          root_dir = lspconfig.util.find_package_json_ancestor,
          single_file_support = false,
        },
        {
          "denols",
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        },
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        -- "cssmodules_ls",
        -- {
        --   "tailwindcss",
        --   root_dir = lspconfig.util.root_pattern("tailwind.config.js"),
        -- },
        "dockerls",
        "taplo",
        "jedi_language_server",
        "terraformls",
        "eslint",
        "biome",
        {
          "graphql",
          filetypes = {
            "graphql",
            "typescriptreact",
            "javascriptreact",
          },
        },
        "pbls",
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for _, lsp in ipairs(servers) do
        local lsp_type = type(lsp)

        if lsp_type == "string" then
          lspconfig[lsp].setup({ capabilities = capabilities })
        elseif lsp_type == "table" then
          lspconfig[lsp[1]].setup({
            filetypes = lsp.filetypes,
            root_dir = lsp.root_dir,
            single_file_support = lsp.single_file_support,
            capabilities = capabilities,
          })
        end
      end
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    opts = {},
  },
}
