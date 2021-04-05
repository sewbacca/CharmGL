
local class = require "CharmGL.aux.class"
local Canvas = require "CharmGL.core.Canvas"
local expect = require "cc.expect".expect

---@class Widget : Super
local Widget = class()

function Widget:__call(element)
	expect(1, self, "table")
	expect(2, element, "table", "nil")

	if not element then return end

	local children = element.children
	element.children = nil
	self:apply(element)
	if children then
		for _, child in ipairs(children) do
			self:append(child)
		end
	end

	return self
end

function Widget:new(...)
	---@type Widget
	local widget = setmetatable({}, {
		__index = self,
		__call = self.__call
	})

	-- Drawing
	---@type Canvas
	widget.canvas = Canvas:new()
	widget.visible = true

	-- Input logic
	widget.focused = nil

	-- Children
	widget.children = { }

	-- Transform logic
	widget.x = nil
	widget.y = nil

	widget.left = 0
	widget.right = 0
	widget.top = 0
	widget.bottom = 0
	widget.width = 0
	widget.height = 0
	widget.horizontalAlignment = "left"
	widget.verticalAlignment = "top"

	---@type Widget
	widget.parent = nil

	widget:init(...)


	return widget
end

--- Init will be called on object creation
function Widget:init()
	
end

function Widget:render()
	local old = term.redirect(self.canvas.term)
	local ok, err = pcall(self.draw, self, self.canvas)
	term.redirect(old)

	if not ok then error(err, 0) end

	return self.canvas
end

--- Appends a child to parent
---@param self table
---@param child any
function Widget:append(child)
	child.parent = self
	table.insert(self.children, child)
end

function Widget:remove(widget)
	for i, child in ipairs(self.children) do
		if child == widget then
			table.remove(self.children, i)
			return true
		end
	end
	return false
end

function Widget:destroy()
	if self.parent then
		self.parent:remove(self)
	end
end

--- Applies element at __call
---@param self table
---@param element any
function Widget:apply(element)
	for k, v in pairs(element) do
		self[k] = v
	end
end

--- Calculates bounds of widget to parent size
---@param self table
---@param parentWidth number
---@param parentHeight number
---@return number @ x
---@return number @ y
---@return number @ width
---@return number @ height
function Widget:bounds(parentWidth, parentHeight)
	expect(1, self, "table")
	expect(2, parentWidth, "number")
	expect(3, parentHeight, "number")

	local x = self.x or self.left + 1
	local y = self.y or self.top + 1
	local width = self.width
	local height = self.height

	if self.horizontalAlignment == "left" then
	elseif self.horizontalAlignment == "right" then
		x = parentWidth - self.width - self.right + 1
	elseif self.horizontalAlignment == "both" then
		width = parentWidth - self.left - self.right
	elseif self.horizontalAlignment == "center" then
		local center = (parentWidth - self.left - self.right) / 2
		x = center - width / 2
	end

	if self.verticalAlignment == "top" then
	elseif self.verticalAlignment == "bottom" then
		y = parentHeight - self.height - self.bottom + 1
	elseif self.verticalAlignment == "both" then
		height = parentHeight - self.top - self.bottom
	elseif self.verticalAlignment == "center" then
		local center = (parentHeight - self.top - self.bottom) / 2
		y = center - height / 2
	end

	return x, y, width, height
end

function Widget:lateupdate()
	
end

function Widget:update()
	
end

function Widget:draw(canvas)
	
end

function Widget:onevent(event, ...)
	
end

return Widget
