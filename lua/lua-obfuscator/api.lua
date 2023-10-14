local M = {}

local call = require('lua-obfuscator.call')

---- UTILS ----
local get_range = function(opts)
    local range
    if opts.range == 2 then range = {start = opts.line1, _end = opts.line2} end
    return range
end

local get_opts = function(opts)
    opts = opts or {}
    opts.range = get_range(opts)
    return opts
end
---- END UTILS ----

M.obfuscateScript = function(opts)
    local script_content = tostring(opts.script_content)
    if script_content == "" then
        return vim.api.nvim_err_writeln("No content to obfuscate")
    end

    local respScriptUpload = call.newScript(script_content)
    if respScriptUpload.error and not respScriptUpload.sessionId then
        vim.api.nvim_err_writeln("\nError uploading script: " .. tostring(respScriptUpload.error))
        return
    end

    local respObf = call.newObfuscateRequest(respScriptUpload.sessionId)
    if respObf.error then
        vim.api.nvim_err_writeln("\nError obfuscating: " .. tostring( respObf.error))
        return
    end
    if not respObf.code then
        vim.api.nvim_err_writeln("\nError obfuscating: obfuscation failed")
        return
    end
    local obfuscatedCode = respObf.code
    local current_bufnr = vim.fn.bufnr()

    -- Replace the entire script with obfuscatedCode
    vim.api.nvim_buf_set_lines(current_bufnr, 0, -1, true, {obfuscatedCode})
end

return M
