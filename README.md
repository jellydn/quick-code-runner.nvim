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
        "<leader>cr",
        ":QuickCodeRunner<CR>",
        desc = "Quick Code Runner",
        mode = "v",
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
    go = {
      "go run",
    },
  },
}
```

## Demo

Simple and user-friendly: choose your code snippet and invoke "QuickCodeRunner" by pressing `<leader>cr`, alternatively.

[![Demo](https://i.gyazo.com/f9c040fda15afa2368c8bedd2ee0dc78.gif)](https://gyazo.com/f9c040fda15afa2368c8bedd2ee0dc78)

## Limitations

Kindly be aware that quick-code-runner.nvim is presently configured to run only JavaScript (JS), TypeScript (TS), Go and Python at this time. Although it might function with other languages, we can't assure full compatibility or offer assistance for problems encountered when employing languages other than JS, TS, Go and Python.

## Contributing

If you wish to support more languages, feel free to open a Pull Request. We appreciate any contributions to expand the capabilities of quick-code-runner.nvim.

Alternatively, if you need to run code in a language not currently supported by quick-code-runner.nvim, you may consider using [code_runner.nvim](https://github.com/CRAG666/code_runner.nvim).

## Credits

Drawing inspiration from the feature-rich [code_runner.nvim](https://github.com/CRAG666/code_runner.nvim), I aim to create a more simple and efficient alternative.

## Author

👤 **Huynh Duc Dung**

- Website: https://productsway.com/
- Twitter: [@jellydn](https://twitter.com/jellydn)
- Github: [@jellydn](https://github.com/jellydn)

## Show your support

If this guide has been helpful, please give it a ⭐️.

[![kofi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/dunghd)
[![paypal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/dunghd)
[![buymeacoffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/dunghd)
