--- Default configuration for quick-code-runner.nvim
local default_config = {
  debug = false,
  file_types = {
    javascript = { 'bun run' },
    typescript = { 'bun run' },
    python = {
      'python3 -u',
    },
    go = {
      'go run',
    },
  },
}
--- Global configuration for entire plugin, easy to access from anywhere
_QUICK_CODE_RUNNER_CONFIG = default_config
local M = {}

--- Setup quick-code-runner.nvim
---@param options (table | nil)
function M.setup(options)
  _QUICK_CODE_RUNNER_CONFIG =
    vim.tbl_extend('force', _QUICK_CODE_RUNNER_CONFIG, options or default_config)

  require('quick-code-runner.main').setup()
end

return M
