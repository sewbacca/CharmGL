
local tools = require "CharmGL.engine.tools"

local function selcol(color, fallback)
	if color == '#' or not color then
		return fallback ~= '#' and fallback or nil
	else
		return color
	end
end

local function pixel_at(widget, x, y)
	local char, foreground, background
	local canvas = widget.canvas
	x, y = x - canvas.x + 1, y - canvas.y + 1

	for _, child in ipairs(widget.children) do
		if child.visible and tools.inbounds(child.canvas, x, y) then
			local child_char, child_foreground, child_background = pixel_at(child, x, y)

			char = char or child_char
			foreground = selcol(foreground, child_foreground)
			background = selcol(background, child_background)

			if char and foreground and background then
				return char, foreground, background
			end
		end
	end

	local widget_char, widget_foreground, widget_background = widget.canvas:get(x, y)
	return char or widget_char,
		selcol(foreground, widget_foreground),
		selcol(background, widget_background)
end

local function render(document, width, height)
	local image = { }
	for y = 1, height do
		local text = { }
		local foreground = { }
		local background = { }

		for x = 1, width do
			local c, f, b = pixel_at(document, x, y)

			c = c or ' '
			f = f or '0'
			b = b or 'f'

			table.insert(text, c)
			table.insert(foreground, f)
			table.insert(background, b)
		end

		image[y] = { table.concat(text), table.concat(foreground), table.concat(background) }
	end
	return image
end

--- Finds cursor in document
---@param document Widget
local function find_cursor(document)
	local canvas = document.canvas

	local blink, x, y, color = canvas.blink, canvas.cursor_x, canvas.cursor_y, canvas.cursor_color

	if document.focused then
		blink, x, y, color = find_cursor(document.focused)

		blink = tools.element_at(document, x, y) == document.focused
	end

	return blink, x + canvas.x - 1, y + canvas.y - 1, color
end

--- Renders document to device
---@param document Widget
---@param device Device
local function draw(document, device)
	local width, height = device:dimensions()

	local image = render(document, width, height)

	for y = 1, #image do
		local line = image[y]
		device:draw(y, line[1], line[2], line[3])
	end

	device:place_cursor(find_cursor(document))
end

return draw