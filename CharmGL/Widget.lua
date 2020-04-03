
local expect = require "cc.expect".expect
local class = require "CharmGL.class"
local Style = require "CharmGL.Style"
local Canvas = require "CharmGL.Canvas"

--- Data representation for an widget
---@class Widget
local Widget = class()

local function apply(widget, attributes)
	expect(1, widget, "table")
	expect(2, attributes, "table")

	for k, v in pairs(attributes) do
		if type(v) == "table" then
			apply(widget[k], v)
		else
			widget[k] = v
		end
	end

	return widget
end

function Widget:new(...)
	local object = setmetatable({ }, {
		__index = self,
		__call = apply
	})

	-- Logic

	object.children = { }

	-- Style (Boundaries)

	self.st_boundaries = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
		horizontalAlignment = "both",
		verticalAlignment = "both",
		width = 10,
		height = 10,
	}

	---@type Style
	object.style = Style:new()
	object.style:append("boundaries", self.st_boundaries)

	---@type Canvas
	object.canvas = Canvas:new()

	object.focused = nil
	object.visible = true

	object:init(...)

	return object
end

---@param parentWidth number
---@param parentHeight number
---@return table
function Widget:bounds(parentWidth, parentHeight)
	expect(1, parentWidth, "number")
	expect(2, parentHeight, "number")

	local style = self.style

	local bounds = {
		x = style.left + 1,
		y = style.top + 1,
		width = style.width,
		height = style.height
	}

	if style.horizontalAlignment == "left" then
	elseif style.horizontalAlignment == "right" then
		bounds.x = parentWidth - style.width - style.right + 1
	elseif style.horizontalAlignment == "both" then
		bounds.width = parentWidth - style.left - style.right
	end

	if style.verticalAlignment == "top" then
	elseif style.verticalAlignment == "bottom" then
		bounds.y = parentHeight - style.height - style.bottom + 1
	elseif style.verticalAlignment == "both" then
		bounds.height = parentHeight - style.top - style.bottom
	end

	return bounds
end

function Widget:append(child)
	self.children[#self.children+1] = child
end

function Widget:remove(child)
	for i = #self.children, 1, -1 do
		if self.children[i] == child then
			self.children[i] = nil
		end
	end
end

return Widget