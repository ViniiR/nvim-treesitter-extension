local M = {}

--- @type NtseOptions
M.values = {
    auto_install = false,
    ensure_installed = {}, --
    ignore_install = {}, --
    sync_install = false, --

    highlight = {
        enable = true, --
        additional_vim_regex_highlighting = {}, -- OPTIONAL
        disable = {},
        use_languagetree = true,
    },

    indent = true, --
}

function M.apply(opts)
    M.values = vim.tbl_extend("force", M.values, opts or {})
end

return M
