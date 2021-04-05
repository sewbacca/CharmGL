
local expect = require "cc.expect".expect
local Device = require "CharmGL.core.Device"
local engine = require "CharmGL.engine"

local CharmGL = { }

CharmGL.devices = {
	term = Device:new(os.pullEvent, term.native());
	rawTerm = Device:new(os.pullEventRaw, term.native());
}

--- Creates a new graphical input output system
---@param input function
---@param output Term
---@return Device
function CharmGL.newDevice(input, output)
	return Device:new(input, output)
end

--- Creates a new application
---@param document Widget
---@param device Device
---@return CharmApp
function CharmGL.newApp(document, device)
	return engine.new_app(document, device)	
end

--- Updating loop for widgets
---@param document Widget
---@param device Device
function CharmGL.run(document, device)
	expect(1, document, "table")
	expect(2, device, "table")

	return engine.new_app(document, device):run()
end

return CharmGL