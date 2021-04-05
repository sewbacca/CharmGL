
local class = require "CharmGL.aux.class"
local hexcolors = require "CharmGL.aux.colors"
local Widget = require "CharmGL.core.Widget"

---@class Button : Widget
local Button = class(Widget)

function Button:init()
	self.text = "Button"
	self.autosize = true
	self.pressed = false

	self.textColor = colors.white
	self.backColor = colors.lime
	self.pressedTextColor = colors.white
	self.pressedBackColor = colors.green
	self.deactiveTextColor = colors.lightGray
	self.deactiveBackColor = colors.gray

	self.canvas.default = { ' ', '0', nil }
end

function Button:update()
	if self.autosize then
		self.width = #self.text
		self.height = 1
	end
end

function Button:onevent(event, btn, x, y)
	if event == "mouse_click" then
		self.pressed = true
	elseif event == "mouse_up" then
		self:onclick()
	elseif event == "mouse_released" then
		self.pressed = false
	end
end

function Button:onclick() end

--- Draws button
---@param self Button
---@param canvas Canvas
function Button:draw(canvas)
	local color = hexcolors[self.pressed and self.pressedTextColor or self.textColor]
	local back = hexcolors[self.pressed and self.pressedBackColor or self.backColor]

	for x = 1, #self.text do
		canvas:set(x, 1, self.text:sub(x, x), color, back)
	end
end

return Button
