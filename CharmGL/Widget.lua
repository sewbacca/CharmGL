
local expect = require "cc.expect".expect
local class = require "CharmGL.class"

--- Data representation for an widget
---@class Widget
local Widget = class()

function Widget:init()
	-- Bounds
	self.left = 0
	self.right = 0
	self.top = 0
	self.bottom = 0
	self.horizontalAlignment = "both"
	self.verticalAlignment = "both"
	self.width = 10
	self.height = 10

	self.paddingLeft = 0
	self.paddingRight = 0
	self.paddingTop = 0
	self.paddingBottom = 0

	-- Children
	self.children = { }
end

---@param parentWidth number
---@param parentHeight number
---@return table
function Widget:bounds(parentWidth, parentHeight)
	expect(1, parentWidth, "number")
	expect(1, parentHeight, "number")

	local bounds = {
		x = self.left + 1,
		y = self.top + 1,
		width = self.width,
		height = self.height
	}

	if self.horizontalAlignment == "left" then
	elseif self.horizontalAlignment == "right" then
		bounds.x = parentWidth - self.width - 1
	elseif self.horizontalAlignment == "both" then
		bounds.width = parentWidth - self.left - self.right
	end

	if self.verticalAlignment == "top" then
	elseif self.verticalAlignment == "bottom" then
		bounds.y = parentHeight - self.height - 1
	elseif self.verticalAlignment == "both" then
		bounds.height = parentHeight - self.top - self.bottom
	end


	return bounds
end

--- Will be called on changes
function Widget:update()
	-- body
end

return Widget