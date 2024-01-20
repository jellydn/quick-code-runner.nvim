local util = {}

--- Get visual selection
---@return string[]
util.get_visual_selection = function()
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
util.create_tmp_file = function(content, filetype)
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
util.create_cmd = function(cmd, func, opt)
  opt = vim.tbl_extend('force', { desc = 'quick-code-runner.nvim ' .. cmd }, opt or {})
  vim.api.nvim_create_user_command(cmd, func, opt)
end

--- Show output in a split view
---@param output string|nil The output to display
util.show_output_in_split = function(output)
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
        bottom = 'Press q to quit',
        bottom_align = 'left',
      },
    },
    position = '50%',
    size = {
      width = '50%',
      height = '50%',
    },
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
util.open_code_pad = function(file_path, filetype)
  local Popup = require('nui.popup')
  local container = Popup({
    enter = true,
    focusable = true,
    position = '50%',
    size = {
      width = '50%',
      height = '50%',
    },
    buf_options = {
      filetype = filetype,
    },
    border = {
      style = 'rounded',
      text = {
        top = ' Code Pad ',
        top_align = 'center',
        bottom = 'Press q to quit',
        bottom_align = 'left',
      },
    },
  })

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

  local file = io.open(file_path, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    vim.api.nvim_buf_set_lines(container.bufnr, 0, -1, false, vim.split(content, '\n'))
  else
    print('Cannot open file ' .. file_path)
  end
end

return util
