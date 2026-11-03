-- Entry point. Real config lives in lua/config and lua/plugins.
require("config.options")
require("config.keymaps")
require("config.lazy")

-- Fall back to built-in theme if catppuccin is not installed yet
if not pcall(vim.cmd.colorscheme, "catppuccin") then
  vim.cmd.colorscheme("habamax")
end
