-- Servers that mason installs and enables. gopls needs Go installed.
local servers = { "lua_ls", "pyright", "vtsls", "tinymist" }

return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = { ensure_installed = servers },
    config = function(_, opts)
      -- Let lua_ls know about the vim global
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
      -- Give every server blink.cmp's completion abilities
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      require("mason-lspconfig").setup(opts)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          -- Built in: K hover, grr refs, gri impl, ]d / [d diagnostics
        end,
      })
    end,
  },
}
