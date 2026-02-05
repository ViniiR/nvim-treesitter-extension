# Nvim-TreeSitter Extension

A protest against nvim-treesitter's main branch rewrite removing most functionality.

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
        },
    },
```
