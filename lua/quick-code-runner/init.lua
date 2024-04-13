--- Get global file path by type
---@param ext string
---@return string
local function get_global_file_by_type(ext)
  local state_path = vim.fn.stdpath('state')
  local path = state_path .. '/code-runner'

  -- Create code-runner folder if it does not exist
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path)
  end

  return string.format('%s/code-pad.%s', path, ext)
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
    lua = {
      'lua',
    },
  },
  global_files = {
    javascript = get_global_file_by_type('js'),
    typescript = get_global_file_by_type('ts'),
    python = get_global_file_by_type('py'),
    go = get_global_file_by_type('go'),
    lua = get_global_file_by_type('lua'),
  },
}

--- Global configuration for entire plugin, easy to access from anywhere
_QUICK_CODE_RUNNER_CONFIG = default_config

local M = {}

--- Setup quick-code-runner.nvim
---@param opts (table | nil)
function M.setup(opts)
  local options = opts or default_config
  _QUICK_CODE_RUNNER_CONFIG = vim.tbl_extend('force', _QUICK_CODE_RUNNER_CONFIG, options)

  require('quick-code-runner.main').setup()
end

return M
