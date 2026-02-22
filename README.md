# Nvim-TreeSitter Extension

A protest against nvim-treesitter's main branch rewrite removing most functionality.

## Goals
This plugin aims to provide some functionality nvim-treesitter removed from its old setup function.

>[!important]
> this plugin does not substitute ```require("nvim-treesitter").setup({})```

To install with lazy.nvim
```lua
{
    "ViniiR/nvim-treesitter-extension"
    branch = "master",
    version = "*", -- Use 'false' to install the latest commit

    -- Loading
    lazy = false, -- Does not support lazy loading

    -- Opts must be included, even if just opts = {}
    opts = {
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

        warn_cli_version = true,
    },
},
```

### Known issues
auto_install may throw an error on some files (e.g. gdscript), this issue comes directly from nvim-treesitter and will only happen once per auto_install. 
> my theory about it is that some background functionality has been completely discarded, meaning vim.treesitter.start() can no longer work with a newly installed parser before a restart.
