require("mason").setup()
require("mason-lspconfig").setup()

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

local servers = {
  "bashls",
  "csharp_ls",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "jqls",
  "jsonls",
  "lua_ls",
  "marksman",
  "omnisharp",
  "pyright",
  "rust_analyzer",
  "sqlls",
  "terraformls",
  "tsserver",
  "yamlls",
}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        single_file_support = true,
    })
end

