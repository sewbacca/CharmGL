
local expect = require "cc.expect".expect
local class = require "CharmGL.class"

---@class Style
local Style = class()

function Style:new(...)
	local object = setmetatable({ }, {
		__index = Style.__index
	})

	object:init(...)

	return object
end

function Style:init()
	self._styles = { }
	self._stack = { }
end

function Style:append(name, style)
	expect(1, self, "table")
	expect(2, name, "string")
	expect(3, style, "table")

	if self._styles[name] ~= nil then
		self:remove(name)
	end

	self._styles[name] = style
	self._stack[#self._stack+1] = style
end

function Style:get(name)
	expect(1, self, "table")
	expect(2, name, "string")

	if not self._styles[name] then
		self:append(name, { })
	end

	return self._styles[name]
end

function Style:remove(name)
	expect(1, self, "table")
	expect(2, name, "string")

	local cmp = self._styles[name]

	if not cmp then return end

	for i = #self._stack, 1, -1 do
		if cmp == self._stack[i] then
			table.remove(self._stack, i)
			break
		end
	end

	self._styles[name] = nil
end

function Style:__index(attribute)
	if Style[attribute] ~= nil then
		return Style[attribute]
	end

	for i = #self._stack, 1, -1 do
		local style = self._stack[i]
		if style[attribute] ~= nil then
			return style[attribute]
		end
	end
end

return Style