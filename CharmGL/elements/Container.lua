
local class = require "CharmGL.aux.class"
local colors = require "CharmGL.aux.colors"
local Widget = require "CharmGL.core.Widget"

---@class Container : Widget
local Container = class(Widget)

function Container:init()
	self.horizontalAlignment = "both"
	self.verticalAlignment = "both"
	self.background = colors.white
end

function Container:draw()
	if self.background == colors.transparent then
		self.canvas.default = { nil, nil, nil, }
	else
		self.canvas.default = { ' ', '0', colors[self.background], }
	end
end

return Container
