require("mason").setup()
require("mason-lspconfig").setup()

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

local servers = {
  "bashls",
  -- "csharp_ls",
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
  -- "omnisharp",
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


vim.env.DOTNET_ROOT = "/opt/homebrew/Cellar/dotnet/8.0.8_1/libexec"
-- Directly execute `csharp-ls` as a standalone binary
-- lspconfig["csharp_ls"].setup({
--     cmd = {
--         "/Users/tobias/.local/share/nvim/mason/packages/csharp-language-server/csharp-ls",
--         "-r:/Applications/Unity/Unity.app/Contents/Managed/UnityEngine.dll",
--         "-r:/Applications/Unity/Unity.app/Contents/Managed/UnityEditor.dll"
--     },
--     on_attach = on_attach,
--     capabilities = capabilities,
--     -- root_dir = lspconfig.util.root_pattern("Assets", "ProjectSettings"),
--     root_dir = lspconfig.util.root_pattern(".sln", ".csproj"),
--     single_file_support = true,
--     settings = {
--         csharp = {
--             enableRoslynAnalyzers = true,
--         },
--     },
-- })

-- Set up OmniSharp to use the .dll with dotnet

lspconfig["omnisharp"].setup({
    cmd = { "dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern("Assets", "ProjectSettings"),
    single_file_support = true,
    settings = {
        omnisharp = {
            enableRoslynAnalyzers = true,
            organizeImportsOnFormat = true,
            useModernNet = true,
            MonoPath = "/Applications/Unity/Unity.app/Contents/Frameworks/MonoEmbedRuntime"
        },
    },
})
