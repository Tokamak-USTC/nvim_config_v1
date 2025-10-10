return {
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-16" },
  },
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "cuda" },
  root_markers = {
    "compile_commands.json",
    ".clangd",
    ".clang-tidy",
    ".clang-format",
  },
  single_file_support = true,
}
