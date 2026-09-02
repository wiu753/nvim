-- render-markdown.nvim: renders markdown nicely in-buffer (headers, tables,
-- checkboxes, code blocks) as you edit, without needing an external tool.
-- https://github.com/MeanderingProgrammer/render-markdown.nvim

---@module 'lazy'
---@type LazySpec
return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown' },
  opts = {},
}
