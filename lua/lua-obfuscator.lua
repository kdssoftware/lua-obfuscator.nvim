local M = {}

local api = require('lua-obfuscator.api')
local obf_commands = {LuaObfuscatorCurrent = api.obfuscateScript}

local create_obf_commands = function()
    for name, obf_api in pairs(obf_commands) do
        vim.api.nvim_create_user_command(name, function(args)
            local bufnr = vim.fn.bufnr("%")
            local script_content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

            obf_api({
                script_content = table.concat(script_content, '\n'),
            })
        end, {
            nargs = '*',
            range = true,
            complete = function()
                local cmdline = vim.fn.getcmdline()
                local _, space_count = string.gsub(cmdline, ' ', '')
                return space_count == 1 and M.anchor_positions or {}
            end
        })
    end
end

M.setup = function(opts) create_obf_commands() end

return M
