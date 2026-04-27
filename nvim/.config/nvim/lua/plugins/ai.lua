-- CodeCompanion: chat + inline AI inside the buffer, talking to Claude.
--
-- API key resolution order: macOS Keychain first, fall back to pass.
-- Store the key once via either:
--   security add-generic-password -a "$USER" -s anthropic_api_key -U -w "<key>"
--   pass insert anthropic/api_key
-- No plaintext key in shell rc files.

return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat', 'CodeCompanionCmd' },
    keys = {
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>',     mode = { 'n', 'v' }, desc = 'AI: actions' },
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'AI: chat toggle' },
      { '<leader>ae', '<cmd>CodeCompanionChat Add<cr>',    mode = 'v',          desc = 'AI: send selection to chat' },
    },
    opts = {
      adapters = {
        http = {
          anthropic = function()
            return require('codecompanion.adapters').extend('anthropic', {
              env = {
                api_key = "cmd:sh -c 'security find-generic-password -ws anthropic_api_key 2>/dev/null || pass anthropic/api_key'",
              },
              schema = {
                model = { default = 'claude-sonnet-4-6' },
              },
            })
          end,
        },
      },
      interactions = {
        chat = { adapter = 'anthropic' },
        inline = { adapter = 'anthropic' },
      },
    },
  },
}
