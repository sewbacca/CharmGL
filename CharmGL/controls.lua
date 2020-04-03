
_G._CONTROLS = _G._CONTROLS or { }

local controls = _CONTROLS

function controls.load(path)
	local env = setmetatable({
		class = require "CharmGL.class",
		Widget = require "CharmGL.Widget",
		hexcolors = require "CharmGL.hexcolors",
		require = require,
		controls = controls
	}, { __index = _G })

	local fun = assert(loadfile(path, env))
	fun()
end

return controls