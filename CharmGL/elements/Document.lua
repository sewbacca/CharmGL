

local class = require "CharmGL.aux.class"
local hexcolors = require "CharmGL.aux.colors"
local Container = require "CharmGL.elements.Container"

---@class Document : Container
local Document = class(Container)

function Document:draw()
	self.canvas.term.setBackgroundColor(self.background)
end

function Document:onevent(event, code)
	if event == "terminate" then
		self:onterminate()
	elseif event == "key" then
		self:onkey(code)
	end
end

function Document:onterminate()
	
end

function Document:onkey(code)
	
end

return Document
