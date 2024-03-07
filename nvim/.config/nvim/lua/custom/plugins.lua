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
      "nomnivore/ollama.nvim",
      branch = "chat",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },

      -- All the user commands added by the plugin
      cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop", "OllamaChat", "OllamaChatClose" },


      keys = {
        -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
        {
          "<leader>oo",
          ":<c-u>lua require('ollama').prompt()<cr>",
          desc = "ollama prompt",
          mode = { "n", "v" },
        },

        -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
        {
          "<leader>oG",
          ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
          desc = "ollama Generate Code",
          mode = { "n", "v" },
        },
      },

      ---@type Ollama.Config
      opts = {
        -- your configuration overrides
      }
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
    }
}

return plugins;
