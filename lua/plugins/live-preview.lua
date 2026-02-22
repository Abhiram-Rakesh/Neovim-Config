return {
  {
    "brianhuster/live-preview.nvim",
    config = function()
      require("live-preview").setup({
        default_options = {
          -- preview = {},
          -- vim.fn.executable("live-preview") == 1,
        }
      })
    end,
  },
}
