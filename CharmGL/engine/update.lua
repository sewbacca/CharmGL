
local expect = require "cc.expect".expect

---@param widget Widget
---@param called table
local function update_impl(widget, called)
	if called[widget] then
		error("Cannot update recursive entries", 2)
	end

	widget:update()
	for _, child in ipairs(widget.children) do
		update_impl(child, called)
	end
	widget:lateupdate()
end

--- Calls update for all ui-elements
---@param document Widget
local function update(document)
	expect(1, document, "table")

	return update_impl(document, {})
end

return update
