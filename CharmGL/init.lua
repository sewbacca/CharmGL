
---@module charmgl
local charmgl = { }

charmgl.screens = {
	term = {
		output = term.native(),
		input = os.pullEvent
	}
}

--- Updating loop for widgets
---@param input table
---@param output table
function charmgl.run(toplevel, screen)
	local input, output = screen.input, screen.output

	local bounds = { }
	local updated = { }

	local function getPixel(node, x, y)
		for i = 1, #node.children do
			local child = node.children[i]

			if child.visible then
				local bounds = bounds[child]

				local xStart, xEnd = bounds.x, bounds.x + bounds.width - 1
				local yStart, yEnd = bounds.y, bounds.y + bounds.height - 1

				if x >= xStart and x <= xEnd and y >= yStart and y <= yEnd then
					return getPixel(child, x - xStart + 1, y - yStart + 1)
				end
			end
		end

		return node.canvas:get(x, y)
	end

	local function onTop(node, x, y)
		for i = 1, #node.children do
			local child = node.children[i]

			if child.visible then
				local bounds = bounds[child]

				local xStart, xEnd = bounds.x, bounds.x + bounds.width - 1
				local yStart, yEnd = bounds.y, bounds.y + bounds.height - 1

				if x >= xStart and x <= xEnd and y >= yStart and y <= yEnd then
					return child
				end
			end
		end

		return nil
	end

	local function boundaries(node, parentWidth, parentHeight)
		if bounds[node] or not node.visible then -- Prevent loopiloops
			return
		end

		local b = node:bounds(parentWidth, parentHeight)
		bounds[node] = b

		for i = 1, #node.children do
			boundaries(node.children[i], b.width, b.height)
		end
	end

	local function update(node)
		if updated[node] or not node.visible then -- Prevent loopiloops
			return
		end
		updated[node] = true

		local b = bounds[node]

		if node.update then
			local old = term.redirect(node.canvas:handle(b.width, b.height))
			local ok, err = pcall(node.update, node, b.width, b.height)
			term.redirect(old)

			if not ok then
				error(err, 0)
			end
		end

		for i = 1, #node.children do
			update(node.children[i])
		end
	end

	local function cycle(node)
		if updated[node] then -- Prevent loopiloops
			return
		end
		updated[node] = true

		if node.cycle then
			node:cycle()
		end

		for i = 1, #node.children do
			cycle(node.children[i])
		end
	end

	local function dispatch(node, ...)
		local event, btn, x, y, arg1, arg2, arg3, arg4 = ...


		if event:match "mouse" or event:match "monitor" then

			local b = bounds[node]

			x = x - b.x + 1
			y = y - b.y + 1

			if event == "mouse_click" then
				node.focused = onTop(node, x, y)
			end
		end

		if node.on then
			node:on(event, btn, x, y, arg1, arg2, arg3, arg4)
		end

		if node.focused then
			dispatch(node.focused, event, btn, x, y, arg1, arg2, arg3, arg4)
		end
	end

	local image = { }

	while true do
		local outputw, outputh = output.getSize()

		-- Update widgets (Boundaries first then content)

		updated = { }
		cycle(toplevel)
		bounds = { } -- Recalc bounds
		boundaries(toplevel, outputw, outputh)
		local width, height = bounds[toplevel].width, bounds[toplevel].height
		updated = { }
		update(toplevel)

		-- Gather changed lines

		local changedLines = { }
		for y = 1, height do
			local t, f, b = { }, { }, { }

			for x = 1, width do
				local _t, _f, _b = getPixel(toplevel, x, y)
				t[x] = _t
				f[x] = _f
				b[x] = _b
			end

			local line = {
				table.concat(t),
				table.concat(f),
				table.concat(b),
			}

			local cmpLine = image[y]

			if cmpLine == nil or
			cmpLine[1] ~= line[1] or
			cmpLine[2] ~= line[2] or
			cmpLine[3] ~= line[3] then
				changedLines[y] = line
				image[y] = line
			end
		end

		-- Render

		local xStart, yStart = bounds[toplevel].x, bounds[toplevel].y
		for y, line in pairs(changedLines) do
			output.setCursorPos(xStart, yStart + y - 1)
			output.blit(line[1], line[2], line[3])
		end

		-- Dispatch events
		dispatch(toplevel, input())
	end
end


return charmgl