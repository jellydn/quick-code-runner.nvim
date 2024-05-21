<h1 align="center">Welcome to quick-code-runner.nvim 👋</h1>
<p>
   Efficient Neovim plugin for running code quickly and simply.
</p>

[![IT Man - Introducing quick-code-runner.nvim - A simple and efficient code runner for Neovim](https://i.ytimg.com/vi/Pz9TZ6AZ1pU/hqdefault.jpg)](https://www.youtube.com/watch?v=Pz9TZ6AZ1pU)

## Features

- **Efficient Code Execution**: Run code snippets swiftly in Neovim.
- **Support for Multiple Languages**: Currently supports JavaScript, TypeScript, Python, and Go.
- **Easy Customization**: Configurable to suit your coding style and requirements.
- **Simple Installation**: Quick setup with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Installation

Add the following to your Neovim configuration to install `quick-code-runner.nvim`:

### Install with [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "jellydn/quick-code-runner.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      debug = true,
    },
    cmd = { "QuickCodeRunner", "QuickCodePad" },
    keys = {
      {
        "<leader>cr",
        ":QuickCodeRunner<CR>",
        desc = "Quick Code Runner",
        mode = "v",
      },
      {
        "<leader>cp",
        ":QuickCodePad<CR>",
        desc = "Quick Code Pad",
      },
    },
  }
```

## Configuration

Customize the plugin by modifying the default configuration. Example:

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

## Usage

- **QuickCodePad**: A tool for writing code snippets in a floating window.
- **QuickCodeRunner**: Run selected code snippets using `<leader>cr`.

### QuickCodePad

The `QuickCodePad` is a tool designed for writing and running code snippets swiftly. It opens a floating window, providing a convenient environment for coding and testing.

![QuickCodePad](https://i.gyazo.com/b6e553ecbf44af51121e67befe4ca0f2.gif)

After closing the floating window, run `:QuickCodeRunner` to execute your code.

This feature is particularly useful when you need a quick, isolated environment for writing and testing code, which you can then run the code by press `Enter`:

[![Run code](https://i.gyazo.com/48c19c3fb6cb42993732082c6628aa1c.gif)](https://gyazo.com/48c19c3fb6cb42993732082c6628aa1c)

### Running Selected Code

The `QuickCodeRunner` feature allows you to select a code snippet and run it with ease. You can invoke this feature using the keyboard shortcut `<leader>cr`.

![QuickCodeRunner](https://i.gyazo.com/f533084934265d331c7edca68e5d80dd.gif)

> [!NOTE]
> The global code block is always executed first, followed by the selected code.

## Limitations

Currently optimized for JavaScript, TypeScript, Go, and Python. May work with other languages, but full compatibility is not guaranteed.

## Tips

- Run `:QuickCodeRunner` to execute the current file. Credits to [@al1-ce](https://github.com/jellydn/quick-code-runner.nvim/issues/33)

```lua
{
    "<leader>cr",
    "gg0vGg$:QuickCodeRunner<CR>",
    desc = "Quick File Code Runner",
    mode = "n",
}
```

## Contributing

If you wish to support more languages, feel free to open a Pull Request. We appreciate any contributions to expand the capabilities of quick-code-runner.nvim.

## Credits

Drawing inspiration from the feature-rich [code_runner.nvim](https://github.com/CRAG666/code_runner.nvim), I aim to create a more simple and efficient alternative.

## Alternative solutions

While quick-code-runner.nvim offers an efficient and simple way to run code in Neovim, other plugins might cater to different requirements or preferences. Here are a few noteworthy alternatives:

- [CRAG666/code_runner.nvim](https://github.com/CRAG666/code_runner.nvim)
- [LintaoAmons/scratch.nvim](https://github.com/LintaoAmons/scratch.nvim)

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
