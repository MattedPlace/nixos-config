-- Language servers supplied by Nix (home/development/nvim.nix).
--
-- Mason is deliberately disabled in mason.lua because Nix owns every binary,
-- and LazyVim's `lang.*` extras are mason-centric — so nothing was telling
-- nvim-lspconfig these servers exist. gopls, rust-analyzer,
-- typescript-language-server and python-lsp-server were all being built and
-- installed but never attached to a buffer; only nixd (wired by hand in
-- nix.lua) actually worked.
--
-- Same shape as nix.lua: declare the server, let lspconfig find the binary on
-- PATH. No mason, no ensure_installed, no download.
--
-- Verify after a change with `:LspInfo` in a file of the relevant type.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {



        -- python-lsp-server. Formatting is handled by black/isort from Nix via
        -- conform, so pylsp's own bundled formatters stay off to avoid two
        -- tools fighting over the same buffer.
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                pycodestyle = { enabled = false },
              },
            },
          },
        },
      },
    },
  },

  -- Parsers for the languages above. nix.lua ensures "nix"; LazyVim's base set
  -- does not cover the rest of this stack.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "json",
        "jsonc",
        "markdown",
        "markdown_inline",
        "bash",
      },
    },
  },
}
