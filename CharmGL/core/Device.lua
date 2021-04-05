
local expect = require "cc.expect".expect
local class = require "CharmGL.aux.class"

---@class Device : Super
local Device = class()

function Device:init(input, output)
	self.input = input
	self.output = output

	self._text_buffer = { }
	self._foreground_buffer = { }
	self._background_buffer = { }
end

--- Register events from device
---@return any @ event, ...
function Device:await()
	return self.input()
end

--- Draws a specified line to screen
---@param y number
---@param text string
---@param foreground string
---@param background string
function Device:draw(y, text, foreground, background)
	expect(1, self, "table")
	expect(2, y, "number")
	expect(3, text, "string")
	expect(4, foreground, "string")
	expect(5, background, "string")

	if self._text_buffer[y] ~= text or
		self._foreground_buffer[y] ~= foreground or
		self._background_buffer[y] ~= background
	then
		self._text_buffer[y] = text
		self._foreground_buffer[y] = foreground
		self._background_buffer[y] = background

		self.output.setCursorPos(1, y)
		return self.output.blit(text, foreground, background)
	end
end

--- Sets the cursor info
---@param blink boolean
---@param x number
---@param y number
---@param color number
function Device:place_cursor(blink, x, y, color)
	expect(1, self, "table")
	expect(2, blink, "boolean")
	expect(3, x, "number", "nil")
	expect(4, y, "number", "nil")
	expect(5, color, "number", "nil")

	self.output.setCursorBlink(blink)
	self.output.setCursorPos(x, y)
	self.output.setTextColor(color)
end

--- Returns width and height of device
---@return number, number
function Device:dimensions()
	return self.output.getSize()
end

return Device
