return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_markers = {
    "package.json",
    "tsconfig.json",
    ".git",
  },
  single_file_support = true,
}
