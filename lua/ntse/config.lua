local M = {}

--- @type NtseOptions
M.values = {
    auto_install = false,
    ensure_installed = {},
    ignore_install = {},
    sync_install = false,

    highlight = {
        enable = true,
        disable = {},
    },

    indent = false, -- experimental
    fold = false,
}

function M.apply(opts)
    M.values = vim.tbl_extend("force", M.values, opts or {})
end

return M
