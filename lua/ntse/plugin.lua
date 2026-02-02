local config = require("ntse.config").values
local ts = require("nvim-treesitter")
local autocmd = vim.api.nvim_create_autocmd

local function ts_install(langs)
    if config.sync_install == nil or config.sync_install then
        ts.install(langs):wait(300000) -- wait max 5min
    else
        ts.install(langs) -- asynchronous
    end
end

local function ts_indent(buf)
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local function ts_highlight(buf, lang)
    if not config.highlight.enable then
        return
    end

    local ok = pcall(vim.treesitter.start, buf, lang)

    if ok and config.indent then
        ts_indent(buf)
    end
end

if config.ensure_installed and #config.ensure_installed > 0 then
    autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
            -- This is a 'noop' if all parsers are already installed
            ts_install(config.ensure_installed)
        end,
    })
end

if config.auto_install then
    autocmd("FileType", {
        callback = function(args)
            if #config.ignore_install > 0 and vim.tbl_contains(config.ignore_install, args.match) then
                return
            end

            local lang = vim.treesitter.language.get_lang(args.match) or args.match

            ts_highlight(args.buf, lang)

            -- TODO: vim.treesitter.start() after install
            ts_install({ lang })
        end,
    })
end
