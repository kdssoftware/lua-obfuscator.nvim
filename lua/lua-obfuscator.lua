local M = {}

local api = require('lua-obfuscator.api')

M.setup = function(opts)
    vim.api.nvim_create_user_command("LuaObfuscatorCurrent",
                                     api.obfuscateScript, {})
end

return M
