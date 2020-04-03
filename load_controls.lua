

local controls = require "CharmGL.controls"
local dir = "/Controls/"

for i, file in pairs(fs.list(dir)) do
	controls.load(dir .. file, file:match("^(.+)%.lua$"))
end