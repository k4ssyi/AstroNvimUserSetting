return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astronvim.utils.status"
      local conditions = require "heirline.conditions"
      local utils = require "heirline.utils"

      local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
      }
      -- We can now define some children separately and add them later

      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self) return self.icon and (self.icon .. " ") end,
        hl = function(self) return { fg = self.icon_color } end,
      }

      local FileName = {
        provider = function(self)
          -- first, trim the pattern relative to the current directory. For other
          -- options, see :h filename-modifers
          local filename = vim.fn.fnamemodify(self.filename, ":~")
          if filename == "" then return "[No Name]" end
          -- now, if the filename would occupy more than 1/4th of the available
          -- space, we trim the file path to its initials
          -- See Flexible Components section below for dynamic truncation
          -- if not conditions.width_percent_below(#filename, 0.25) then filename = vim.fn.pathshorten(filename) end
          return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
      }

      local FileFlags = {
        {
          condition = function() return vim.bo.modified end,
          provider = "[+]",
          hl = { fg = "green" },
        },
        {
          condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
          provider = "",
          hl = { fg = "orange" },
        },
      }

      -- Now, let's say that we want the filename color to change if the buffer is
      -- modified. Of course, we could do that directly using the FileName.hl field,
      -- but we'll see how easy it is to alter existing components using a "modifier"
      -- component

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force = true }
          end
        end,
      }

      -- let's add the children to our FileNameBlock component
      FileNameBlock = utils.insert(
        FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = "%< " } -- this means that the statusline is cut here when there's not enough space
      )

      opts.statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
        status.component.file_info { filetype = {}, filename = false, file_modified = false },
        FileNameBlock,
        status.component.git_branch(),
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.treesitter(),
        status.component.nav(),
      }

      opts.winbar = { -- winbar
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        fallthrough = false,
        { -- inactive winbar
          condition = function() return not status.condition.is_active() end,
          status.component.separated_path(),
          status.component.file_info {
            file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
            file_modified = false,
            file_read_only = false,
            hl = status.hl.get_attributes("winbarnc", true),
            surround = false,
            update = "BufEnter",
          },
        },
        { -- active winbar
          status.component.breadcrumbs { hl = status.hl.get_attributes("winbar", true) },
        },
      }

      opts.tabline = { -- tabline
        { -- file tree padding
          condition = function(self)
            self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
            return status.condition.buffer_matches(
              { filetype = { "aerial", "dapui_.", "neo%-tree", "NvimTree" } },
              vim.api.nvim_win_get_buf(self.winid)
            )
          end,
          provider = function(self) return string.rep(" ", vim.api.nvim_win_get_width(self.winid) + 1) end,
          hl = { bg = "tabline_bg" },
        },
        status.heirline.make_buflist(status.component.tabline_file_info()), -- component for each buffer tab
        status.component.fill { hl = { bg = "tabline_bg" } }, -- fill the rest of the tabline with background color
        { -- tab list
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
          status.heirline.make_tablist { -- component for each tab
            provider = status.provider.tabnr(),
            hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
          },
          { -- close button for current tab
            provider = status.provider.close_button { kind = "TabClose", padding = { left = 1, right = 1 } },
            hl = status.hl.get_attributes("tab_close", true),
            on_click = {
              callback = function() require("astronvim.utils.buffer").close_tab() end,
              name = "heirline_tabline_close_tab_callback",
            },
          },
        },
      }

      opts.statuscolumn = { -- statuscolumn
        status.component.foldcolumn(),
        status.component.fill(),
        status.component.numbercolumn(),
        status.component.signcolumn(),
      }

      -- return the final configuration table
      return opts
    end,
  },
}
