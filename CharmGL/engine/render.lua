
local function round(...)
	local args = { ... }

	for i, arg in ipairs(args) do
		args[i] = math.floor(arg + 0.5)
	end

	return table.unpack(args)
end

--- Recalculates positioning for document
---@param document Widget
---@param parent_width number
---@param parent_height number
local function render(document, parent_width, parent_height)
	local x, y, width, height = document:bounds(parent_width, parent_height)
	document.canvas:reposition(round(x, y, width, height))
	document:render()
	for _, child in ipairs(document.children) do
		render(child, width, height)
	end
end

return render