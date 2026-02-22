local config = require("ntse.config").values
local ts = require("nvim-treesitter")
local autocmd = vim.api.nvim_create_autocmd

local disabled_filetypes = {
    "dashboard",
}

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

local function ts_fold()
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
end

local function ts_highlight(buf, lang)
    local is_installed = vim.tbl_contains(require("nvim-treesitter").get_installed(), lang)
    if not is_installed then
        return
    end

    local is_active = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
    if is_active then
        return
    end

    local disabled = config.highlight.disable or {}
    if vim.tbl_contains(disabled, lang) then
        -- use only vim's syntax and not treesitter
        return
    end

    local ok = pcall(vim.treesitter.start, buf, lang)

    if ok and config.indent then
        ts_indent(buf)
    end
    if ok and config.fold then
        ts_fold()
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
            -- do not install these parsers
            if #config.ignore_install > 0 and vim.tbl_contains(config.ignore_install, args.match) then
                return
            end

            local lang = vim.treesitter.language.get_lang(args.match) or args.match

            -- Early skip dashboard since it does not offer anything
            if vim.tbl_contains(disabled_filetypes, lang) then
                return
            end

            local is_installed = vim.tbl_contains(require("nvim-treesitter").get_installed(), lang)
            if is_installed then
                return
            end

            ts_install({ lang })

            -- Enable highlight 5 seconds after installing a new parser
            -- without this the parser auto installs but only ever highlights the second time you open a filetype
            -- NOTE: may not work with some filetypes such as gdscript, it seems to be an issue with nvim-treesitter and not NTsE
            vim.defer_fn(function()
                if config.highlight.enable then
                    ts_highlight(args.buf, lang)
                end
            end, 5000)
        end,
    })
end

if config.highlight.enable then
    autocmd("FileType", {
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match) or args.match

            -- Early skip dashboard since it does not offer anything
            if vim.tbl_contains(disabled_filetypes, lang) then
                return
            end

            ts_highlight(args.buf, lang)
        end,
    })
end

local function parse_version(value)
    if type(value) == "string" then
        local version = {}
        local val = value:gsub("tree.sitter ", "")
        for str in val:gmatch("([^\\.]+)") do
            if tonumber(str) ~= nil then
                table.insert(version, tonumber(str))
            end
        end
        return version
    end

    local version = {}
    for _, val in ipairs(value) do
        if val:find("TREE_SITTER_MIN_VER") then
            -- local parsed = val:gsub("local TREE_SITTER_MIN_VER =", "")
            for str in val:gmatch("([^%s]+)") do
                str = str:gsub(",", "")
                if tonumber(str) ~= nil then
                    table.insert(version, tonumber(str))
                end
            end
        end
    end
    return version
end

local function make_version(str)
    return string.format("%s.%s.%s", str[1], str[2], str[3])
end

if config.warn_cli_version then
    local res = vim.system({
        "tree-sitter",
        "--version",
    }):wait()
    if res.code ~= 0 then
        vim.notify("Treesitter cli was not found", vim.log.levels.ERROR)
        return
    end

    -- NOTE: i'm aware this is a hacky way to get the version but it is what is is.
    local health_file =
        vim.fn.readfile(vim.api.nvim_get_runtime_file("lua/nvim-treesitter/health.lua", false)[1], nil, 30)

    local min_version = parse_version(health_file)
    local version = parse_version(res.stdout)

    local message =
        string.format("Expected version '%s', got version '%s'", make_version(min_version), make_version(version))

    -- Major
    if version[1] > min_version[1] then
        return
    end

    -- Patch
    if version[1] == min_version[1] and version[2] == min_version[2] and version[3] < min_version[3] then
        vim.notify(message, vim.log.levels.ERROR)
        return
    end

    -- Minor
    if version[1] == min_version[1] and version[2] >= min_version[2] then
        return
    end

    vim.notify(message, vim.log.levels.ERROR)
end
