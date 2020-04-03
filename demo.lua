
shell.run("/load_controls")
local charmgl = require "CharmGL"
local controls = require "CharmGL.controls"

---@type Widget
local root = controls.Desktop:new()
---@type Widget
local window = controls.Window:new(1, 1, 10, 10)

root:append(window)

charmgl.run(root, charmgl.screens.term)
