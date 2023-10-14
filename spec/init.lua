local cwd = vim.fn.getcwd()
vim.o.runtimepath = vim.o.runtimepath .. string.format(',%s', cwd)

require('lua-obfuscator').setup()
vim.cmd.cd('tests/data')
