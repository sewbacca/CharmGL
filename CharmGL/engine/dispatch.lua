
local tools = require "CharmGL.engine.tools"

local POINTER_EVENTS = {
	monitor_touch = true,
	mouse_click = true,
	mouse_drag = true,
	mouse_scroll = true,
	mouse_up = true,
}

local KEYBOARD_EVENTS = {
	terminate = true,
	paste = true,
	key = true,
	key_up = true,
	char = true,
}

local function send_all(document, ...)
	document:onevent(...)

	for _, child in ipairs(document) do
		send_all(child, ...)
	end
end

local function send_focused(document, ...)
	document:onevent(...)

	if document.focused then
		return send_focused(document, document.focused)
	end
end

local function raycast(document, collector, x, y)
	x, y = x - document.canvas.x + 1, y - document.canvas.y + 1
	table.insert(collector, document)

	for _, child in ipairs(document.children) do
		if tools.inbounds(child.canvas, x, y) then
			return raycast(child, collector, x, y)
		end
	end

	return collector
end

local function send_raycast(elements, event, arg, x, y)
	for _, element in ipairs(elements) do
		x, y = x - element.canvas.x + 1, y - element.canvas.y + 1

		element:onevent(event, arg, x, y)
	end
end

local function send_pointer(document, meta, event, arg, x, y)
	local mouse_state = meta.mouse_state or "up"

	if event == "mouse_click" then
		if meta.mouse_click then
			send_raycast(meta.mouse_click, "mouse_released", arg, x, y)
		end

		meta.mouse_click = raycast(document, { }, x, y)

		send_raycast(meta.mouse_click, event, arg, x, y)

		mouse_state = "down"
	elseif event == "mouse_drag" then
		send_raycast(meta.mouse_click, event, arg, x, y)
	elseif event == "mouse_up" then
		if meta.mouse_click then
			send_raycast(meta.mouse_click, "mouse_released", arg, x, y)
			meta.mouse_click = nil
		end

		send_raycast(raycast(document, {}, x, y), event, arg, x, y)
	end

	meta.mouse_state = mouse_state
end

--- Awaits an event from device and dispatches it into the document
---@param document Widget
---@param device Device
local function dispatch(document, meta, device)
	local event_args = { device:await() }
	local event = event_args[1]

	if POINTER_EVENTS[event] then
		send_pointer(document, meta, table.unpack(event_args))
	elseif KEYBOARD_EVENTS[event] then
		send_focused(document, table.unpack(event_args))
	else
		send_all(document, table.unpack(event_args))
	end
end

return dispatch
