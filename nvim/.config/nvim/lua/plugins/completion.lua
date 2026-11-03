return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- release tag ships a prebuilt fuzzy binary
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" }, -- C-y accept, C-n/C-p move
      completion = { documentation = { auto_show = true } },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },
}
