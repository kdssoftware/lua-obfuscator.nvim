local M = {}
local json = require("lua-obfuscator.json")

-- TODO port to utils 

local settings = {
    minifyAll = true,
    virtualize = false,
    customPlugins = {
        SwizzleLookups = 100,
        EncryptStrings = 100,
        RevertAllIfStatements = 50,
        ControlFlowFlattenAllBlocks = 75
    }
}
local settingsData = {
    MinifiyAll = settings.minifyAll,
    Virtualize = settings.virtualize,
    CustomPlugins = {
        SwizzleLookups = {settings.customPlugins.SwizzleLookups},
        EncryptStrings = {settings.customPlugins.EncryptStrings},
        RevertAllIfStatements = {settings.customPlugins.RevertAllIfStatements},
        ControlFlowFlattenAllBlocks = {
            settings.customPlugins.ControlFlowFlattenAllBlocks
        }
    }
}

-- @param script string: Lua script to be obfuscated
-- @return table: Returns a table with session ID and error message, both of which can be nil or string.
M.newScript = function(script)
    local endpoint = "https://luaobfuscator.com/api/obfuscator/newscript"
    local headers = "-H 'Content-type: text/plain' -H 'apikey:test'"

    local requestBody = json.encode({script = script})

    local command = string.format('curl -X POST %s -s %s --data-raw %q',
                                  requestBody, endpoint, headers)
    local result = vim.fn.system(command)

    if vim.v.shell_error ~= 0 then
        return {code = nil, error = "Error executing the command."}
    end

    local response = json.decode(result)
    if not response then
        return {sessionId = nil, error = "Error decoding Lua response."}
    end

    if response and response.sessionId then
        local sessionId = tostring(response.sessionId)
        return {sessionId = sessionId, error = nil}
    else
        return {sessionId = nil, error = "Error decoding Lua response."}
    end
end

-- @param sessionId string: The session ID obtained from script upload.
-- @return table: Returns a table with obfuscated code and error message, both of which can be nil or string.
M.newObfuscateRequest = function(sessionId)
    local endpoint = "https://luaobfuscator.com/api/obfuscator/obfuscate/"

    local headers =
        "-H 'Content-type: text/plain' -H 'apikey: test' -H 'sessionId: " ..
            sessionId .. "'"

    local command = string.format('curl -X POST %s -s %s --data-raw %q',
                                  endpoint, headers, json.encode(settingsData))
    local result = vim.fn.system(command)

    if vim.v.shell_error ~= 0 then
        return {code = nil, error = "Error executing the command."}
    end

    local response = json.decode(result)
    if response.title == "Unauthorized" then
        return {
            code = nil,
            error = "Looks like the server is down: \n" .. tostring(result)
        }
    end

    if string.find(result, '"code":null', 1, true) then -- could try to use response.code
        return {code = nil, error = "failed to obfuscate: " .. tostring(result)}
    end

    -- Interpret the Lua code in the response
    if response and type(response) == "table" and response.code then
        return {
            code = response.code,
            error = nil
        }
    else
        return {
            code = nil,
            error = "Error decoding Lua response or missing 'code' field."
        }
    end
end

return M
