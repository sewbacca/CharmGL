
local class = require "CharmGL.aux.class"
local colors = require "CharmGL.aux.colors"
local Widget = require "CharmGL.core.Widget"

local Button = require "CharmGL.elements.Button"
local Box = require "CharmGL.elements.Box"
local Container = require "CharmGL.elements.Container"
local Label = require "CharmGL.elements.Label"

---@class Window : Widget
local Window = class(Widget)

function Window:init()
	self.width = 15
	self.height = 10
	self.title = "Empty Window"
	self.background = colors.lightGray

	self._container = Container:new () {
		top = 1;
	}

	local x_old, y_old = self.x, self.y
	local dragging = false

	self.x = 1
	self.y = 1

	self._titlebar = Label:new() {
		right = 3;
		horizontalAlignment = "both";
		backColor = colors.blue;
		textColor = colors.white;
		onevent = function(label, event, _, x, y)
			if event == "mouse_click" then
				x_old, y_old = x, y
				dragging = true
			elseif event == "mouse_drag" and dragging then
				self.x, self.y = self.x + x - x_old, self.y + y - y_old
			elseif event == "mouse_release" then
				dragging = false
			end
		end
	}

	self.children = {
		self._titlebar,
		Box:new() {
			growdir = "left";
			horizontalAlignment = "right";
			children = {
				Button:new() {
					text = "X";
					backColor = colors.orange;
					pressedBackColor = colors.red;
					onclick = function ()
						if self:onclose() ~= false then
							self:destroy()
						end
					end
				},
			}
		},
		self._container
	}
end

function Window:update()
	self._titlebar.text = self.title
	self._container.background = self.background
end

function Window:draw()
	term.setBackgroundColor(self.background)
end

function Window:onclose()
	
end

function Window:append(child)
	return self._container:append(child)
end

return Window
