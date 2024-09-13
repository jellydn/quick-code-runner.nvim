local M = {}

local log = require('quick-code-runner.vlog')

local filetype_to_extension = {
  javascript = 'js',
  typescript = 'ts',
  python = 'py',
  go = 'go',
}

--- Get visual selection
---@return string[]
M.get_visual_selection = function()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return lines
end

--- Create tmp file
---@param content any
---@param filetype string
---@return string|nil
M.create_tmp_file = function(content, filetype)
  -- create temp file base on pid and datetime
  local tmp_file = string.format(
    '%s/%s.%s',
    vim.fn.stdpath('cache'),
    vim.fn.getpid() .. '-' .. vim.fn.localtime(),
    filetype
  )

  if not tmp_file then
    vim.notify('quick-code-runner: failed to create tmp file', vim.log.levels.ERROR)
    return
  end

  local f = io.open(tmp_file, 'w')
  if not f then
    return
  end
  if type(content) == 'table' then
    local c = vim.fn.join(content, '\n')
    f:write(c)
  else
    f:write(content)
  end
  f:close()

  return tmp_file
end

--- Create custom command
---@param cmd string The command name
---@param func function The function to execute
---@param opt table The options
M.create_cmd = function(cmd, func, opt)
  opt = vim.tbl_extend('force', { desc = 'quick-code-runner.nvim ' .. cmd }, opt or {})
  vim.api.nvim_create_user_command(cmd, func, opt)
end

--- Show output in a split view
---@param output string|nil The output to display
M.show_output_in_split = function(output)
  local Popup = require('nui.popup')
  local event = require('nui.utils.autocmd').event

  local container = Popup({
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
      text = {
        top = ' Code Runner ',
        top_align = 'center',
        bottom = 'Press `q` to quit',
        bottom_align = 'left',
      },
    },
    position = _QUICK_CODE_RUNNER_CONFIG.position,
    size = _QUICK_CODE_RUNNER_CONFIG.size,
  })

  -- mount/open the component
  container:mount()

  -- unmount component when 'q' is pressed
  container:map('n', 'q', function()
    container:unmount()
  end)

  -- unmount component when cursor leaves buffer
  container:on(event.BufLeave, function()
    container:unmount()
  end)

  local content = output
  -- Fallback to empty string if output is nil
  if not content or #content == 0 then
    content = 'No output'
  end

  vim.api.nvim_buf_set_lines(container.bufnr, 0, 1, false, vim.split(content, '\n'))
end

--- Open code pad with the given file path
---@param file_path string
---@param filetype string
M.open_code_pad = function(file_path, filetype)
  local Popup = require('nui.popup')
  local container = Popup({
    enter = true,
    focusable = true,
    position = _QUICK_CODE_RUNNER_CONFIG.position,
    size = _QUICK_CODE_RUNNER_CONFIG.size,
    buf_options = {
      filetype = filetype,
    },
    border = {
      style = 'rounded',
      text = {
        top = ' Code Pad ',
        top_align = 'center',
        bottom = 'Press `q` to quit - `Enter` to save and execute code',
        bottom_align = 'left',
      },
    },
  })

  -- NOTE: Show relative line number on the buffer

  -- mount/open the component
  container:mount()

  local function quit()
    vim.cmd('q')
    -- Get buffer content
    local lines = vim.api.nvim_buf_get_lines(container.bufnr, 0, -1, false)
    local content = table.concat(lines, '\n')

    -- Write buffer content to file
    local file = io.open(file_path, 'w')
    if file then
      file:write(content)
      file:close()
    else
      print('Cannot open file ' .. file_path)
    end
    container:unmount()
  end

  -- unmount component when 'q' is pressed
  container:map('n', 'q', function()
    quit()
  end)

  local function save_and_execute()
    quit()
    -- Get buffer content
    M.run_lines({}, {})
  end
  -- Map <C-Enter> to save and execute
  container:map('n', '<Enter>', function()
    save_and_execute()
  end)

  local file = io.open(file_path, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    vim.api.nvim_buf_set_lines(container.bufnr, 0, -1, false, vim.split(content, '\n'))
  else
    print('Cannot open file ' .. file_path)
  end
end

--- Create a temporary file with the lines to run
---@param lines string[]
---@param opts table The options
function M.run_lines(lines, opts)
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
  local fname = M.create_tmp_file(global_lines, extension)
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
    M.show_output_in_split(output)
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

return M
