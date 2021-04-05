
local transparent = 2^16
local argb = setmetatable({
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
	[ transparent      ] = '#',
}, {
	__index = function (_, k)
		error("Key " .. tostring(k) .. " (type " .. type(k) .. ") not found inside constant map", 2)
	end
})

argb.white = colors.white
argb.orange = colors.orange
argb.magenta = colors.magenta
argb.lightBlue = colors.lightBlue
argb.yellow = colors.yellow
argb.lime = colors.lime
argb.pink = colors.pink
argb.gray = colors.gray
argb.lightGray = colors.lightGray
argb.cyan = colors.cyan
argb.purple = colors.purple
argb.blue = colors.blue
argb.brown = colors.brown
argb.green = colors.green
argb.red = colors.red
argb.black = colors.black
argb.transparent = transparent

return argb