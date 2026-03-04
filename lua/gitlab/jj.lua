local M = {}

---Runs a system command and returns the output and error
---@param command table
---@return string|nil, string|nil
local run_system = function(command)
  local result = vim.fn.trim(vim.fn.system(command))
  if vim.v.shell_error ~= 0 then
    require("gitlab.utils").notify(result, vim.log.levels.ERROR)
    return nil, result
  end
  return result, nil
end

---Returns true if the current project is a jujutsu repository (has a .jj directory)
---@return boolean
M.is_jj_repo = function()
  local base_dir, err = require("gitlab.git").base_dir()
  if err or base_dir == nil then
    return false
  end
  return vim.fn.isdirectory(base_dir .. "/.jj") == 1
end

---Snapshots the current working copy changes by running `jj new`,
---which creates a new empty working-copy commit and leaves the git
---working tree in a clean state.
---@return string|nil, string|nil
M.snapshot_changes = function()
  return run_system({ "jj", "new" })
end

return M
