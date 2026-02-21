return {
  {
    "brianhuster/live-preview.nvim",
    config = function()
      require("live-preview").setup({
        port = 8080,
        browser = "firefox", -- or "chromium", "brave"
      })
    end
  }
}

