
local expect = require "cc.expect".expect
local class = require "CharmGL.aux.class"

local engine = {
	update = require "CharmGL.engine.update",
	render = require "CharmGL.engine.render",
	draw = require "CharmGL.engine.draw",
	dispatch = require "CharmGL.engine.dispatch",
}

---@class CharmApp : Super
local CharmApp = class()

function CharmApp:init(document, device)
	self.document = document
	self.device = device
	self.running = true
	self.event_container = { }
end

function CharmApp:exit()
	self.running = false
end

function CharmApp:run()
	while self.running do
		engine.update(self.document)
		engine.render(self.document, self.device:dimensions())
		engine.draw(self.document, self.device)
		engine.dispatch(self.document, self.event_container, self.device)
	end
end

--- Creates a new app, which wraps update, render and dispatch
---@param document Widget
---@param device Device
---@return CharmApp
function engine.new_app(document, device)
	expect(1, document, "table", "nil")
	expect(2, device, "table", "nil")

	return CharmApp:new(document, device)
end

return engine
