local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn

-- Add health check for bun, go and python3
function M.check()
  start('quick-code-runner.nvim health check')
  local bun = vim.fn.executable('bun')
  if bun == 0 then
    warn('bun not found')
  else
    ok('bun found')
  end

  local go = vim.fn.executable('go')
  if go == 0 then
    warn('go not found')
  else
    ok('go found')
  end

  local python3 = vim.fn.executable('python3')
  if python3 == 0 then
    warn('python3 not found')
  else
    ok('python3 found')
  end
end

return M
