
local hexcolors = setmetatable({
	[ colors.white     ] = '0',
	[ colors.orange    ] = '1',
	[ colors.magenta   ] = '2',
	[ colors.lightBlue ] = '3',
	[ colors.yellow    ] = '4',
	[ colors.lime      ] = '5',
	[ colors.pink      ] = '6',
	[ colors.gray      ] = '7',
	[ colors.lightGray ] = '8',
	[ colors.cyan      ] = '9',
	[ colors.purple    ] = 'a',
	[ colors.blue      ] = 'b',
	[ colors.brown     ] = 'c',
	[ colors.green     ] = 'd',
	[ colors.red       ] = 'e',
	[ colors.black     ] = 'f',
}, {
	__index = function (_, k)
		error("Key " .. tostring(k) .. " (type " .. type(k) .. ") not found inside constant map", 2)
	end
})

-- Make it bidirectional

local bidirectionalcolors = { }
for k, v in pairs(hexcolors) do
	bidirectionalcolors[v] = k
end

-- Merge

for k, v in pairs(bidirectionalcolors) do
	hexcolors[k] = v
end

return hexcolors