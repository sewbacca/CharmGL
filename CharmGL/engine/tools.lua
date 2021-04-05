
local tools = { }

--- If given pixel is inside canvas
---@param canvas Canvas
---@param x number
---@param y number
---@return boolean
function tools.inbounds(canvas, x, y)
	local xstart, xend = canvas.x, canvas.x + canvas.width - 1
	local ystart, yend = canvas.y, canvas.y + canvas.height - 1
	return x >= xstart and x <= xend and y >= ystart and y <= yend
end

--- Returns top most element at x, y
---@param document Widget
---@param x number
---@param y number
---@return Widget | nil
function tools.element_at(document, x, y)
	for _, child in ipairs(document.children) do
		if tools.inbounds(child.canvas, x, y) then
			return child
		end
	end

	return nil
end


return tools
