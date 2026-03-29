return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "single",
          icons = {
            package_installed   = "◆",
            package_pending     = "◇",
            package_uninstalled = "○",
          },
        },
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          "jsonls",
          "yamlls",
          "pyright",
        },
        automatic_installation = true,
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map  = vim.keymap.set
        local opts = { buffer = bufnr }
        map("n", "gd",         vim.lsp.buf.definition,    opts)
        map("n", "gr",         vim.lsp.buf.references,    opts)
        map("n", "K",          vim.lsp.buf.hover,         opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action,   opts)
        map("n", "<leader>rn", vim.lsp.buf.rename,        opts)
        map("n", "<leader>d",  vim.diagnostic.open_float, opts)
        map("n", "[d",         vim.diagnostic.goto_prev,  opts)
        map("n", "]d",         vim.diagnostic.goto_next,  opts)
      end

      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach    = on_attach,
      })

      vim.lsp.enable({
        "lua_ls", "bashls", "jsonls", "yamlls", "pyright"
      })

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "◆",
            [vim.diagnostic.severity.HINT]  = "◇",
            [vim.diagnostic.severity.INFO]  = "○",
          }
        },
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
      })
    end
  },
}
