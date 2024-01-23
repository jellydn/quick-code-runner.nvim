local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn

--- Find and check if an executable is present
---@param executable string
---@param version_option string
local function check_executable(executable, version_option)
  local is_present = vim.fn.executable(executable)
  if is_present == 0 then
    warn(executable .. ' not found')
  else
    local success, version = pcall(vim.fn.system, executable .. ' ' .. version_option)
    if success then
      ok(executable .. ' found, version: ' .. version)
    else
      warn('Failed to get version of ' .. executable)
    end
  end
end

-- Add health check for bun, go and python3
function M.check()
  start('quick-code-runner.nvim health check')
  check_executable('bun', '--version')
  check_executable('go', 'version')
  check_executable('python3', '--version')
end

return M
