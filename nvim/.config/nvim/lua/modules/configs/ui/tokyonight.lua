return function()
  local transparent = require("core.settings").transparent_background

  require("modules.utils").load_plugin("tokyonight", {
    style = "storm",
    transparent = transparent,
    styles = {
      comments = { italic = true },
      functions = { bold = true },
      keywords = { italic = true },
      operators = { bold = true },
      conditionals = { bold = true },
      loops = { bold = true },
      booleans = { bold, italic = true },
    },
    sidebars = { "neo-tree", "trouble", "qf", "Outline" },
    day_brightness = 0.3,
    hide_inactive_statusline = false,
    dim_inactive = false,
    lualine_bold = false,
    on_highlights = function(hl, c)
      -- transparent background overrides
      if transparent then
        hl.Normal = { fg = c.fg, bg = c.none }
        hl.NormalFloat = { fg = c.fg, bg = c.none }
        hl.FloatBorder = { fg = c.blue, bg = c.none }
        hl.Pmenu = { fg = c.fg_dark, bg = c.none }
        hl.PmenuSel = { bg = c.bg_highlight, fg = c.fg }
        hl.PmenuBorder = { fg = c.border_highlight, bg = c.none }
        hl.TelescopeBorder = { fg = c.blue, bg = c.none }
        hl.TelescopeNormal = { bg = c.none }
        hl.TelescopeTitle = { fg = c.blue, bg = c.none }
        hl.TelescopePromptBorder = { fg = c.blue, bg = c.none }
        hl.TelescopePromptNormal = { bg = c.none }
        hl.TelescopeResultsTitle = { fg = c.blue, bg = c.none }
        hl.TelescopePreviewTitle = { fg = c.green, bg = c.none }
        hl.SignColumn = { bg = c.none }
        hl.StatusLine = { bg = c.none }
        hl.StatusLineNC = { bg = c.none }
        hl.TabLine = { bg = c.none }
        hl.TabLineFill = { bg = c.none }
        hl.VertSplit = { bg = c.none }
        hl.EndOfBuffer = { bg = c.none }
        hl.CursorLineNr = { fg = c.red, bg = c.none }
        -- Mason
        hl.MasonNormal = { link = "NormalFloat" }
        -- Nvim-notify
        hl.NotifyBackground = { bg = c.bg }
        -- Trouble
        hl.TroubleNormal = { bg = c.none }
        hl.TroubleNormalNC = { bg = c.none }
      end

      -- lualine-like statusline highlights for non-catppuccin theme
      hl.CursorLine = { bg = transparent and c.none or c.bg_highlight }
      hl.IblIndent = { fg = c.bg_highlight }
      hl.IblScope = { fg = c.comment, bold = true }
      hl.LspInfoBorder = { link = "FloatBorder" }
      hl.FidgetTask = { fg = c.comment }
      hl.FidgetTitle = { fg = c.blue, bold = true }

      -- diagnostics
      hl.DiagnosticVirtualTextError = { bg = c.none }
      hl.DiagnosticVirtualTextWarn = { bg = c.none }
      hl.DiagnosticVirtualTextInfo = { bg = c.none }
      hl.DiagnosticVirtualTextHint = { bg = c.none }

      -- cmp
      hl.CmpItemAbbr = { fg = c.fg_dark }
      hl.CmpItemAbbrMatch = { fg = c.blue, bold = true }
      hl.CmpDoc = { link = "NormalFloat" }
      hl.CmpDocBorder = { fg = transparent and c.border_highlight or c.bg, bg = transparent and c.none or c.bg }

      -- codecompanion
      hl.CodeCompanionChatHeader = { fg = c.blue, bold = true }

      -- === NEON GLOW TREESITTER HIGHLIGHTS (Tokyo Night Storm) ===
      -- Keywords - Pink
      hl["@keyword"] = { fg = "#bb9af7", bold = true }
      hl["@keyword.function"] = { fg = "#bb9af7", bold = true }
      hl["@keyword.operator"] = { fg = "#bb9af7", bold = true }
      hl["@keyword.conditional"] = { fg = "#7dcfff", bold = true }
      hl["@keyword.repeat"] = { fg = "#7dcfff", bold = true }
      hl["@keyword.import"] = { fg = "#bb9af7", bold = true }
      hl["@keyword.type"] = { fg = "#bb9af7", bold = true }
      hl["@keyword.storage"] = { fg = "#bb9af7", bold = true }
      hl["@keyword.return"] = { fg = c.none }

      -- Functions - Cyan
      hl["@function"] = { fg = "#7dcfff", bold = true }
      hl["@function.call"] = { fg = "#7dcfff", bold = true }
      hl["@function.builtin"] = { fg = "#7dcfff", bold = true }
      hl["@function.macro"] = { fg = "#7dcfff", bold = true }
      hl["@method"] = { fg = "#73daca", bold = true }
      hl["@method.call"] = { fg = "#73daca", bold = true }

      -- Variables
      hl["@variable"] = { fg = "#c0caf5" }
      hl["@variable.builtin"] = { fg = "#ff9e64", italic = true }
      hl["@variable.parameter"] = { fg = "#ff9e64", italic = true }
      hl["@variable.member"] = { fg = "#c0caf5" }

      -- Types/Classes - Yellow
      hl["@type"] = { fg = "#e0af68", bold = true }
      hl["@type.builtin"] = { fg = "#e0af68", bold = true }
      hl["@type.definition"] = { fg = "#e0af68", bold = true }
      hl["@class"] = { fg = "#e0af68", bold = true }

      -- Strings - Green
      hl["@string"] = { fg = "#9ece6a" }
      hl["@string.documentation"] = { fg = "#9ece6a", italic = true }
      hl["@string.regexp"] = { fg = "#f7768e" }
      hl["@string.escape"] = { fg = "#bb9af7" }
      hl["@string.special"] = { fg = "#bb9af7" }

      -- Numbers - Purple
      hl["@number"] = { fg = "#bb9af7" }
      hl["@number.float"] = { fg = "#bb9af7" }
      hl["@boolean"] = { fg = "#bb9af7", bold = true, italic = true }

      -- Operators - Pink
      hl["@operator"] = { fg = "#bb9af7", bold = true }

      -- Punctuation
      hl["@punctuation.delimiter"] = { fg = "#c0caf5" }
      hl["@punctuation.bracket"] = { fg = "#c0caf5" }
      hl["@punctuation.special"] = { fg = "#bb9af7" }

      -- Constants - Orange
      hl["@constant"] = { fg = "#ff9e64", bold = true }
      hl["@constant.builtin"] = { fg = "#ff9e64", bold = true }
      hl["@constant.macro"] = { fg = "#ff9e64", bold = true }

      -- Properties/Fields - Teal
      hl["@property"] = { fg = "#73daca" }
      hl["@field"] = { fg = "#73daca" }
      hl["@attribute"] = { fg = "#73daca" }

      -- Comments - subtle
      hl["@comment"] = { fg = "#565f89", italic = true }
      hl["@comment.documentation"] = { fg = "#565f89", italic = true }

      -- Tags (HTML/XML) - Pink/Cyan
      hl["@tag"] = { fg = "#bb9af7", bold = true }
      hl["@tag.attribute"] = { fg = "#73daca" }
      hl["@tag.delimiter"] = { fg = "#c0caf5" }

      -- Labels - Cyan
      hl["@label"] = { fg = "#7dcfff" }

      -- Constructor - Green
      hl["@constructor"] = { fg = "#9ece6a", bold = true }

      -- Namespace/Module - Purple
      hl["@namespace"] = { fg = "#bb9af7", italic = true }
      hl["@module"] = { fg = "#bb9af7", italic = true }

      -- Interface - Yellow
      hl["@interface"] = { fg = "#e0af68", bold = true }

      -- Decorator - Orange
      hl["@decorator"] = { fg = "#ff9e64" }

      -- Error from treesitter
      hl["@error.c"] = { fg = c.none }
      hl["@error.cpp"] = { fg = c.none }
    end,
  })
end
