-- CodeCompanion: chat + inline AI inside the buffer.
--
-- Two adapters available:
--   - anthropic (default) — talks to api.anthropic.com, claude-sonnet-4-6
--   - ollama             — talks to local Ollama, default qwen3-coder:latest
--
-- Anthropic API key resolves from macOS Keychain first, then pass:
--   security add-generic-password -a "$USER" -s anthropic_api_key -U -w "<key>"
--   pass insert anthropic/api_key
-- No plaintext key in shell rc files.
--
-- Ollama needs no key. Pull a coder model once:
--   ollama pull qwen3-coder
-- Then `,ao` opens a chat against ollama instead of Anthropic.
-- To pick a different model in-chat: type `:` then change the `model` field
-- in the chat header, or list installed models with `curl localhost:11434/api/tags`.

return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat', 'CodeCompanionCmd' },
    keys = {
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>',           mode = { 'n', 'v' }, desc = 'AI: actions' },
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>',       mode = { 'n', 'v' }, desc = 'AI: chat toggle (Claude)' },
      { '<leader>ao', '<cmd>CodeCompanionChat adapter=ollama<cr>', mode = { 'n', 'v' }, desc = 'AI: new chat (Ollama)' },
      { '<leader>ae', '<cmd>CodeCompanionChat Add<cr>',          mode = 'v',          desc = 'AI: send selection to chat' },
      { '<leader>am', '<cmd>CodeCompanion /buffer<cr>',          mode = { 'n', 'v' }, desc = 'AI: include current buffer' },
    },
    opts = {
      adapters = {
        http = {
          opts = {
            -- `ga` inside a chat buffer opens a vim.ui.select with all
            -- adapters, then all models for that adapter. Ollama populates
            -- its model list by hitting /api/tags on the running server.
            show_model_choices = true,
          },
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
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              env = {
                url = function()
                  return os.getenv('OLLAMA_HOST') or 'http://localhost:11434'
                end,
              },
              schema = {
                model = { default = 'qwen3-coder:latest' },
                num_ctx = { default = 32768 },
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
