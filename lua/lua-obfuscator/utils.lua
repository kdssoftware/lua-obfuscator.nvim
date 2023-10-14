local M = {}

M.copyToClipboard = function (str)
    local cmd
    if vim.fn.has("win32") == 1 then
        -- Windows
        cmd = 'echo ' .. str .. '| clip'
    elseif vim.fn.has("unix") == 1 then
        -- Linux/Unix
        cmd = 'echo "' .. str .. '" | xclip -selection clipboard'
    elseif vim.fn.has("mac") == 1 then
        -- macOS
        cmd = 'echo "' .. str .. '" | pbcopy'
    else
        print("Unsupported operating system")
        return
    end

    local success, _, code = os.execute(cmd)
    if not success or code ~= 0 then
        print("Error copying to clipboard")
    else
        print("String copied to clipboard")
    end
end

return M
