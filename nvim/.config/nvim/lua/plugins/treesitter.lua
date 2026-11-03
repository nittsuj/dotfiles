-- nvim-treesitter main branch: install parsers, then start
-- highlighting per buffer. Needs the tree-sitter CLI.
local parsers = {
  "bash", "go", "html", "css", "javascript", "typescript", "tsx", "vue",
  "json", "lua", "markdown", "markdown_inline", "python", "typst", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      if vim.fn.executable("tree-sitter") == 1 then
        require("nvim-treesitter").install(parsers)
      end
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
