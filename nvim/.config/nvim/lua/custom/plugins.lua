local plugins = {
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        config = function ()
            require("plugins.configs.lspconfig")
            require("custom.configs.lspconfig")
        end
    },
    {
      "nvim-lualine/lualine.nvim",
      optional = true,

      opts = function(_, opts)
        table.insert(opts.sections.lualine_x, {
          function()
            local status = require("ollama").status()

            if status == "IDLE" then
              return "󱙺" -- nf-md-robot-outline
            elseif status == "WORKING" then
              return "󰚩" -- nf-md-robot
            end
          end,
          cond = function()
            return package.loaded["ollama"] and require("ollama").status() ~= nil
          end,
        })
      end,
    },
}

return plugins;
