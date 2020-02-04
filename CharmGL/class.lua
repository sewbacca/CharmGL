
-- A really simple class design

local Object = { }

function Object:new( ... )
	local obj = setmetatable({}, { __index = self })
	obj:init(...)
	return obj
end

function Object:init( ... )
	-- body
end

return function (parent)
	return setmetatable({}, {
		__index = parent or Object
	})
end