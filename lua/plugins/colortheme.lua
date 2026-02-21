return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Default transparency flag
    local bg_transparent = true

    -- Function to toggle transparency
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      require('tokyonight').setup {
        transparent = bg_transparent,
        -- you could also re-specify the other settings here if needed
      }
      vim.cmd [[colorscheme tokyonight]]
    end

    -- Setup tokyonight with options (before applying the colorscheme)
    require('tokyonight').setup {
      style = 'night', -- “storm”, “moon”, “night”, “day” :contentReference[oaicite:0]{index=0}
      transparent = bg_transparent, -- disable background (transparent) (similar to nord_disable_background)
      terminal_colors = true, -- if you want terminal colors to match
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
        -- you can set bold/underline etc here too
      },
      sidebars = 'dark', -- style for sidebar (like NvimTree) (“dark”, “transparent”, or specific list) :contentReference[oaicite:1]{index=1}
      day_brightness = 0.3, -- amount to brighten day style (if using day) :contentReference[oaicite:2]{index=2}
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false, -- whether section headers in lualine should be bold
      on_colors = function(colors) -- override or adjust specific colors if you want
        -- e.g. colors.border = some_color
      end,
      on_highlights = function(highlights, colors)
        -- you can override highlight groups too
      end,
    }

    -- Apply the colorscheme
    vim.cmd [[colorscheme tokyonight]]

    -- Map a key to toggle transparency
    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
