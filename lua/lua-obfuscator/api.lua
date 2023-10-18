local M = {}

local call = require('lua-obfuscator.call')

M.obfuscateScript = function()
    local bufnr = vim.fn.bufnr("%")
    local script_content_table = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local script_content = table.concat(script_content_table, '\n')
    if script_content == "" then
        return vim.api.nvim_err_writeln("No content to obfuscate")
    end

    local respScriptUpload = call.newScript(script_content)
    if respScriptUpload.error and not respScriptUpload.sessionId then
        vim.api.nvim_err_writeln("\nError uploading script: " ..
                                     tostring(respScriptUpload.error))
        return
    end

    local respObf = call.newObfuscateRequest(respScriptUpload.sessionId)
    if respObf.error then
        vim.api.nvim_err_writeln("\nError obfuscating: " ..
                                     tostring(respObf.error))
        return
    end
    if not respObf.code then
        vim.api.nvim_err_writeln("\nError obfuscating: obfuscation failed")
        return
    end
    local obfuscatedCode = respObf.code
    local current_bufnr = vim.fn.bufnr()

    vim.api.nvim_buf_set_lines(current_bufnr, 0, -1, true, {obfuscatedCode})
end

return M
