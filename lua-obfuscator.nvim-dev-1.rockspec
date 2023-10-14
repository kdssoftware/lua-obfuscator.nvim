package = "lua-obfuscator.nvim"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/kdssoftware/lua-obfuscator.nvim.git"
}
description = {
   summary = "## Commands- `LuaObfuscatorCurrent` : obfuscated ",
   detailed = [[

## Commands
- `LuaObfuscatorCurrent` : obfuscated 
]],
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      ["lua-obfuscator"] = "lua/lua-obfuscator.lua",
      ["lua-obfuscator.api"] = "lua/lua-obfuscator/api.lua",
      ["lua-obfuscator.call"] = "lua/lua-obfuscator/call.lua",
      ["lua-obfuscator.json"] = "lua/lua-obfuscator/json.lua"
   },
   copy_directories = {
      "doc"
   }
}
