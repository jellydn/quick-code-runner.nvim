<h1 align="center">Welcome to quick-code-runner.nvim 👋</h1>
<p>
  A simple and efficient code runner for Neovim.
</p>

## Usage

To use quick-code-runner.nvim, add the following configuration to your Neovim setup:

### Install with [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "jellydn/quick-code-runner.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      debug = true,
    },
    cmd = "QuickCodeRunner",
    keys = {
      {
        "<leader>qr",
        ":QuickCodeRunner<CR>",
        desc = "Quick Code Runner",
        mode = { "n", "v" },
      },
    },
  }
```

## Configuration

You can customize quick-code-runner.nvim by modifying the default configuration:

```lua
--- Default configuration for quick-code-runner.nvim
local default_config = {
  debug = false, -- Print debug information
  file_types = {
    javascript = { 'bun run' }, -- Run command for javascript, you can change to `node` or `deno`
    typescript = { 'bun run' }, -- Run command for typescript, you can change to `npx tsx run` or `deno`
    python = {
      'python3 -u', -- Run command for python
    },
  },
}
```

## Demo

Simple and user-friendly: choose your code snippet and invoke "QuickCodeRunner" by pressing `<leader>q r`, alternatively.

[![Demo](https://i.gyazo.com/f9c040fda15afa2368c8bedd2ee0dc78.gif)](https://gyazo.com/f9c040fda15afa2368c8bedd2ee0dc78)

## Credits

Inspired by [code_runner.nvim](https://github.com/CRAG666/code_runner.nvim) but with simple and efficient.

## Show your support

Give a ⭐️ if this project helped you!
