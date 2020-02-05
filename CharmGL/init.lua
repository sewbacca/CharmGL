
local class = require "CharmGL.class"
local Widget = require "CharmGL.Widget"
local Canvas = require "CharmGL.Canvas"

---@module charmgl
local charmgl = { }

charmgl.input = {
	os = os.pullEvent
}

charmgl.output = {
	os = term.native()
}

---@param root Widget
---@return Frame
function charmgl.createFrame(root)
	---@class Frame
	local frame = { }

	local canvases = { }
	local bounds = { }

	local width, height = 0, 0

	local function gather(node, w, h)
		canvases[node] = canvases[node] or Canvas:new()
		bounds[node] = node:bounds(w, h)
		local bounds = bounds[node]

		for i = 1, #node.children do
			gather(node.children[i], bounds.width, bounds.height)
		end
	end

	function frame.init(w, h)
		width, height = w, h
		gather(root, w, h)
	end


	local function pass(node, event, btn, x, y, ...)
		if node.on then
			node:on(event, btn, x, y, ...)
		end

		if event:match "monitor" or event:match "mouse" then
			for i = 1, #node.children do
				local child = node.children[i]

				local bounds = bounds[child]

				local xStart, xEnd = bounds.x, bounds.x + bounds.width - 1
				local yStart, yEnd = bounds.y, bounds.y + bounds.height - 1

				if x >= xStart and x <= xEnd and y >= yStart and y <= yEnd then
					return pass(child, event, btn, x - xStart + 1, y - yStart + 1, ...)
				end
			end
		else
			for i = 1, #node.children do
				pass(node.children[i], event, btn, x, y, ...)
			end
		end
	end

	function frame.passEvent(event, ...)
		pass(root, event, ...)
	end

	local function update(node, w, h)
		local bounds = bounds[node]

		local oldTerm = term.redirect(canvases[node]:handle(bounds.width, bounds.height))
		node:update()
		term.redirect(oldTerm)

		for i = 1, #node.children do
			update(node.children[i], bounds.width, bounds.height)
		end
	end

	function frame.update()
		update(root, width, height)
	end

	local function get(node, x, y)
		for i = 1, #node.children do
			local child = node.children[i]

			local bounds = bounds[child]

			local xStart, xEnd = bounds.x, bounds.x + bounds.width - 1
			local yStart, yEnd = bounds.y, bounds.y + bounds.height - 1

			if x >= xStart and x <= xEnd and y >= yStart and y <= yEnd then
				return get(child, x - xStart + 1, y - yStart + 1)
			end
		end

		return canvases[node]:get(x, y)
	end

	function frame.changedLines()
		local changedLines = { }

		for y = 1, height do
			local t, f, b = { }, { }, { }

			for x = 1, width do
				local _t, _f, _b = get(root, x, y)
				t[x] = _t
				f[x] = _f
				b[x] = _b
			end

			changedLines[y] = {
				table.concat(t),
				table.concat(f),
				table.concat(b),
			}
		end

		return changedLines
	end

	return frame
end

--- Updating loop for widgets
---@param frame Frame
---@param input table
---@param output table
function charmgl.run(frame, input, output)
	input = input or charmgl.input.os
	output = output or charmgl.output.os

	while true do
		frame.init(output.getSize())

		frame.update()

		for y, line in pairs(frame.changedLines()) do
			output.setCursorPos(1, y)
			output.blit(line[1], line[2], line[3])
		end

		frame.passEvent(input())
	end
end


return charmgl