--- Get global file path by type
---@param ext string
---@return string
local function get_global_file_by_type(ext)
  -- Create code-runner folder if not exists
  if vim.fn.isdirectory(vim.fn.stdpath('state') .. '/code-runner') == 0 then
    vim.fn.mkdir(vim.fn.stdpath('state') .. '/code-runner')
  end

  return string.format('%s/%s/code-pad.%s', vim.fn.stdpath('state'), 'code-runner', ext)
end

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
  global_files = {
    javascript = get_global_file_by_type('js'),
    typescript = get_global_file_by_type('ts'),
    python = get_global_file_by_type('py'),
    go = get_global_file_by_type('go'),
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
