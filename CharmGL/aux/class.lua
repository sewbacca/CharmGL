
-- A really simple class design

---@class Super
local Super = { }
Super.__index = Super

--- Creates a new object
---@return table
function Super:new(...)
	local obj = setmetatable({}, self)
	obj:init(...)
	return obj
end

function Super:init() end

return function (parent)
	parent = parent or Super
	local class = setmetatable({}, parent)
	class.__index = class
	class.base = parent
	return class
end
