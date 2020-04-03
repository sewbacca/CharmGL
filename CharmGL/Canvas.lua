

local expect = require "cc.expect".expect
local class = require "CharmGL.class"
local hex = require "CharmGL.hexcolors"

--- Wraps term for our needs
---@class Canvas
local Canvas = class()

function Canvas:init()
	self.buffer = { }
	self.ptrbuffer = { }

	self.yoffset = 0
	self.x = 1
	self.y = 1
	self.blink = false
	self.default = {
		' ',
		'0',
		'f'
	}

	self.width = 0
	self.height = 0

	---@type Term|nil
	self._handle = nil
end

function Canvas:defaultpixel()
	expect(1, self, "table")
	return self.default[1], self.default[2], self.default[3]
end

--- Sets a pixel at x, y
---@param x number
---@param y number
---@param t string
---@param f string
---@param b string
function Canvas:set(x, y, t, f, b)
	expect(1, self, "table")
	expect(2, x, "number")
	expect(3, y, "number")

	expect(4, t, "string")
	expect(5, f, "string")
	expect(6, b, "string")

	assert(#t == #f, "Arguments must be the same length")
	assert(#t == #b, "Arguments must be the same length")

	self.buffer[y] = self.buffer[y] or { }
	self.buffer[y][x] = {
		t,
		f,
		b
	}
end

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

--- There will be at most one single handle to each canvas!!!
---@param width number
---@param height number
---@return Term
function Canvas:handle(width, height)
	expect(1, self, "table")
	expect(2, width, "number")
	expect(3, height, "number")

	self.width = width
	self.height = height

	if self._handle then
		return self._handle
	end

	self._handle = { }
	---@class Term
	local handle = self._handle

	function handle.write(text)
		expect(1, text, "string")

		local _, f, b = self:defaultpixel()
		return handle.blit(text, f:rep(#text), b:rep(#text))
	end

	function handle.blit(text, textCol, backCol)
		expect(1, text, "string")
		expect(2, textCol, "string")
		expect(3, backCol, "string")

		if #text ~= #textCol or #text ~= #backCol then
			error("Arguments must be the same size", 2)
		end

		for i = 1, #text do
			local t, f, b = text:sub(i, i), textCol:sub(i, i), backCol:sub(i, i)
			self:set(self.x + i - 1 ,self.y + self.yoffset, t, f, b)
		end

		self.x = self.x + #text
	end

	function handle.setCursorPos(x, y)
		expect(1, x, "number")
		expect(2, y, "number")

		self.x = x
		self.y = y
	end

	function handle.getCursorPos()
		return self.x, self.y
	end

	function handle.getCursorBlink()
		return self.blink
	end

	function handle.setCursorBlink(blink)
		expect(1, blink, "boolean")
		self.blink = blink
	end

	function handle.setBackgroundColor(col)
		expect(1, col, "number")
		self.default[3] = hex[col]
	end
	handle.setBackgroundColour = handle.setBackgroundColor

	function handle.setTextColor(col)
		expect(1, col, "number")
		self.default[2] = hex[col]
	end
	handle.setTextColour = handle.setTextColor

	function handle.getTextColor()
		local _, col, _ = self:defaultpixel()
		return hex[col]
	end
	handle.getTextColour = handle.getTextColor

	function handle.getBackgroundColor()
		local _, _, col = self:defaultpixel()
		return hex[col]
	end
	handle.getBackgroundColour = handle.getBackgroundColor

	function handle.getSize()
		return self.width, self.height
	end

	function handle.clear()
		self.buffer = { }
	end

	function handle.clearLine()
		self.buffer[self.y + self.yoffset] = nil
	end

	function handle.scroll(n)
		self.yoffset = self.yoffset - n
	end

	function handle.isColor()
		return true
	end
	handle.isColour = handle.isColor

	return handle
end

return Canvas