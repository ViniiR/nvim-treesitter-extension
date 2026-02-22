---@class NtseHlOpt
--- Whether to enable treesitter highlight
---@field enable boolean?
--- Array of parsers to disable (never highlight)
---@field disable string[]?

---@class NtseOptions
--- Array of parsers to ensure are installed every time nvim is opened
---@field ensure_installed string[]?
--- Whether to install parsers synchronously or asynchronously
---@field sync_install boolean?
--- Whether to install its parser when opening a new filetype 
---@field auto_install boolean?
--- Array of parsers to never install
---@field ignore_install string[]?
--- Whether to use treesitter's indent expr
--- WARNING: nvim-treesitter marks this as experimental
---@field indent boolean?
--- Whether to use treesitter's fold expr
--- NOTE: you must set foldmethod externally
---@field fold boolean?
---@field highlight NtseHlOpt?
--- Check if tree-sitter cli version matches
---@field warn_cli_version boolean?

---@alias NtseOpts NtseOptions

local types = {}

return types
