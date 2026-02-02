local config = require("ntse.config")
local M = {}

function M.setup(opts)
    config.apply(opts)
    require("ntse.plugin")
end

return M
