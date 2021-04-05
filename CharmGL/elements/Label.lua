
local class = require "CharmGL.aux.class"
local colors = require "CharmGL.aux.colors"
local Widget = require "CharmGL.core.Widget"

---@class Label : Widget
local Label = class(Widget)

function Label:init()
	self.text = "Label"
	self.autosize = true
	self.pressed = false

	self.textColor = colors.black
	self.backColor = colors.transparent

	self.canvas.default = { ' ', '0', nil }
end

function Label:update()
	if self.autosize then
		self.width = #self.text
		self.height = 1
	end
end

--- Draws button
---@param self Button
---@param canvas Canvas
function Label:draw(canvas)
	local color = colors[self.textColor]
	local back = colors[self.backColor]

	for x = 1, #self.text do
		canvas:set(x, 1, self.text:sub(x, x), color, back)
	end
end

return Label
