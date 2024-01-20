local utils = require('quick-code-runner.utils')
local log = require('quick-code-runner.vlog')

local M = {}

local filetype_to_extension = {
  javascript = 'js',
  typescript = 'ts',
  python = 'py',
  go = 'go',
}

--- Create a temporary file with the lines to run
---@param lines string[]
---@param opts table The options
local function run_lines(lines, opts)
  -- Create a temporary file with the lines to run
  local filetype = vim.bo.filetype

  local global_fname = _QUICK_CODE_RUNNER_CONFIG.global_files[filetype]
  local global_lines = {}
  if global_fname then
    local f = io.open(global_fname, 'r')
    if f then
      for line in f:lines() do
        table.insert(global_lines, line)
      end
      f:close()
    else
      -- Create the global file if it doesn't exist
      f = io.open(global_fname, 'w')
      if f then
        f:close()
      else
        vim.notify(
          'Could not create global file ' .. global_fname,
          vim.log.levels.WARN,
          { title = 'quick-code-runner.nvim' }
        )
        return
      end
    end
  end

  -- Append the lines from the selection
  for _, line in ipairs(lines) do
    table.insert(global_lines, line)
  end

  local extension = filetype_to_extension[filetype]
  local fname = utils.create_tmp_file(global_lines, extension)
  if not fname then
    vim.notify(
      'Create tmp file failed. Please try again!',
      vim.log.levels.WARN,
      { title = 'quick-code-runner.nvim' }
    )
    return
  end

  -- Add the temporary file to the arguments
  local cmd = _QUICK_CODE_RUNNER_CONFIG.file_types[filetype]
  if not cmd then
    vim.notify(
      'No command for filetype ' .. filetype,
      vim.log.levels.WARN,
      { title = 'quick-code-runner.nvim' }
    )
    if _QUICK_CODE_RUNNER_CONFIG.debug then
      log.warn('quick-code-runner: No command for filetype ' .. filetype)
    end
    return
  end

  -- Run command
  local cli = table.concat(cmd, ' ') .. ' ' .. fname
  if _QUICK_CODE_RUNNER_CONFIG.debug then
    log.info(cli)
  end

  local output = vim.fn.system(cli)
  if vim.v.shell_error ~= 0 then
    vim.notify('quick-code-runner: command failed with error: ' .. output, vim.log.levels.ERROR)
    if _QUICK_CODE_RUNNER_CONFIG.debug then
      log.error('quick-code-runner: command failed with error: ' .. output)
    end
  else
    utils.show_output_in_split(output)
  end

  -- Clean up the temporary file after a delay
  local timeout = 1000
  vim.defer_fn(function()
    local success = os.remove(fname)
    if not success then
      vim.notify('quick-code-runner: remove file failed', vim.log.levels.WARN)
    end
  end, timeout)
end

--- Run selection
---@param opts table The options
local function run_selection(opts)
  opts = opts or {}
  local lines = utils.get_visual_selection()
  if not lines then
    return
  end

  run_lines(lines, opts)
end

function M.setup()
  utils.create_cmd('QuickCodeRunner', function(opts)
    if opts.range ~= 0 then
      run_selection(opts.fargs)
    else
      vim.notify('No selection', vim.log.levels.WARN, { title = 'quick-code-runner.nvim' })
    end
  end, { nargs = '*', range = true })

  utils.create_cmd('QuickCodePad', function()
    local filetype = vim.bo.filetype
    local global_fname = _QUICK_CODE_RUNNER_CONFIG.global_files[filetype]
    if global_fname then
      vim.cmd('split ' .. global_fname)
    else
      vim.notify(
        'No global file for filetype ' .. filetype,
        vim.log.levels.WARN,
        { title = 'quick-code-runner.nvim' }
      )
    end
  end, { nargs = '*', range = true })
end

return M
