
local class = require "CharmGL.aux.class"
local Container = require "CharmGL.core.Container"

local ANCHOR = {
	right = "left",
	left = "right",
	top = "bottom",
	bottom = "top",
}

local SIZE = {
	right = "width",
	left = "width",
	top = "height",
	bottom = "height",
}

local H_ALIGN = {
	right = true,
	left = true
}

local V_ALIGH = {
	top = true,
	bottom = true,
}

---@class Box : Container
local Box = class(Container)

function Box:init()
	self.growdir = "right"
	self.padding = 0
end

function Box:lateupdate()
	local margin = 0

	for _, child in ipairs(self.children) do
		child[ANCHOR[self.growdir]] = margin
		child.horizontalAlginment = H_ALIGN[self.growdir] and ANCHOR[self.growdir] or child.horizontalAlginment
		child.verticalAlginment = V_ALIGH[self.growdir] and ANCHOR[self.growdir] or child.verticalAlginment
		margin = margin + child[SIZE[self.growdir]] + self.padding

		self.height = math.max(self.height, child.height)
	end

	self.width = margin - self.padding
end

return Box
