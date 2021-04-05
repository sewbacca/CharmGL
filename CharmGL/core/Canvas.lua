
local expect = require "cc.expect".expect
local class = require "CharmGL.aux.class"
local hexcolors = require "CharmGL.aux.colors"

--- Wraps term for our needs
---@class Canvas : Super
local Canvas = class()

--- Sets a pixel at x, y
---@param x number
---@param y number
---@param char string
---@param foreground string
---@param background string
function Canvas:set(x, y, char, foreground, background)
	expect(1, self, "table")
	expect(2, x, "number")
	expect(3, y, "number")

	expect(4, char, "string", "nil")
	expect(5, foreground, "string", "nil")
	expect(6, background, "string", "nil")

	assert(not char or #char == 1, "Arguments must be chars")
	assert(not foreground or #foreground == 1, "Arguments must be chars")
	assert(not background or #background == 1, "Arguments must be chars")

	self.buffer[y] = self.buffer[y] or { }
	self.buffer[y][x] = {
		char,
		foreground,
		background
	}
end

--- Gets pixel at x, y
---@param x number
---@param y number
---@return string
---@return string
---@return string
function Canvas:get(x, y)
	expect(1, self, "table")
	expect(2, x, "number")
	expect(3, y, "number")

	y = y + self.yoffset

	if not self.buffer[y] or not self.buffer[y][x] then
		return self:defaultpixel()
	end

	local p = self.buffer[y][x]
	return p[1], p[2], p[3]
end

--- Resizes canvas
---@param width number
---@param height number
function Canvas:reposition(x, y, width, height)
	expect(1, self, "table")
	expect(2, width, "number")
	expect(3, height, "number")

	self.x = x
	self.y = y
	self.width = width
	self.height = height
end

--- Returns current default pixel
---@return string
---@return string
---@return string
function Canvas:defaultpixel()
	expect(1, self, "table")
	return self.default[1], self.default[2], self.default[3]
end

function Canvas:init()
	self.buffer = { }

	self.yoffset = 0
	self.cursor_x = 1
	self.cursor_y = 1
	self.cursor_color = colors.white

	self.blink = false
	self.default = {
		' ',
		'0',
		'f'
	}

	self.x = 1
	self.y = 1
	self.width = 0
	self.height = 0

	---@class Term
	local term = { }

	function term.write(text)
		text = tostring(text)

		local _, f, b = self:defaultpixel()
		return term.blit(text, f:rep(#text), b:rep(#text))
	end

	function term.blit(text, textCol, backCol)
		expect(1, text, "string")
		expect(2, textCol, "string")
		expect(3, backCol, "string")

		if #text ~= #textCol or #text ~= #backCol then
			error("Arguments must be the same size", 2)
		end

		for i = 1, #text do
			local t, f, b = text:sub(i, i), textCol:sub(i, i), backCol:sub(i, i)
			self:set(self.cursor_x + i - 1, self.cursor_y + self.yoffset, t, f, b)
		end

		self.cursor_x = self.cursor_x + #text
	end

	function term.setCursorPos(x, y)
		expect(1, x, "number")
		expect(2, y, "number")

		self.cursor_x = x
		self.cursor_y = y
	end

	function term.getCursorPos()
		return self.cursor_x, self.cursor_y
	end

	function term.getCursorBlink()
		return self.blink
	end

	function term.setCursorBlink(blink)
		expect(1, blink, "boolean")
		self.blink = blink
	end

	function term.setBackgroundColor(col)
		expect(1, col, "number")
		self.default[3] = hexcolors[col]
	end
	term.setBackgroundColour = term.setBackgroundColor

	function term.setTextColor(col)
		expect(1, col, "number")
		self.default[2] = hexcolors[col]
		self.cursor_color = col
	end
	term.setTextColour = term.setTextColor

	function term.getTextColor()
		local _, col, _ = self:defaultpixel()
		return hexcolors[col]
	end
	term.getTextColour = term.getTextColor

	function term.getBackgroundColor()
		local _, _, col = self:defaultpixel()
		return hexcolors[col]
	end
	term.getBackgroundColour = term.getBackgroundColor

	function term.getSize()
		-- print() assumes that width > 0
		local width = math.max(1, self.width)
		local height = math.max(1, self.height)
		return width, height
	end

	function term.clear()
		self.buffer = { }
	end

	function term.clearLine()
		self.buffer[self.cursor_y + self.yoffset] = nil
	end

	function term.scroll(n)
		self.yoffset = self.yoffset + n
	end

	function term.isColor()
		return true
	end
	term.isColour = term.isColor

	---@type Term
	self.term = term
end

return Canvas