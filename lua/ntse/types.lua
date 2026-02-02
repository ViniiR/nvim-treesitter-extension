---@class NtseHlOpt
---@field enable boolean?
---@field use_languagetree boolean? -- TODO:
---@field disable string[] | function ? -- TODO:
---@field additional_vim_regex_highlighting string[]? -- TODO:

---@class NtseOptions
---@field ensure_installed string[]?
---@field sync_install boolean?
---@field auto_install boolean?
---@field ignore_install string[]?
---@field indent boolean?
---@field highlight NtseHlOpt?

---@alias NtseOpts NtseOptions

local types = {}

return types
