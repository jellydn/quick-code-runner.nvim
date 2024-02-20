local utils = require('quick-code-runner.utils')

local M = {}

--- Run selection
---@param opts table The options
local function run_selection(opts)
  opts = opts or {}
  local lines = utils.get_visual_selection()
  if not lines then
    return
  end

  utils.run_lines(lines, opts)
end

function M.setup()
  utils.create_cmd('QuickCodeRunner', function(opts)
    if opts.range ~= 0 then
      run_selection(opts.fargs)
    else
      vim.notify(
        'Execute global code block..',
        vim.log.levels.INFO,
        { title = 'quick-code-runner.nvim' }
      )
      utils.run_lines({}, {})
    end
  end, { nargs = '*', range = true })

  utils.create_cmd('QuickCodePad', function()
    local filetype = vim.bo.filetype
    local global_fname = _QUICK_CODE_RUNNER_CONFIG.global_files[filetype]
    if global_fname then
      utils.open_code_pad(global_fname, filetype)
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
