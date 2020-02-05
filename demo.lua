
local charmgl = require "CharmGL"
local Widget = require "CharmGL.Widget"

---@type Widget
local node = Widget:new()
---@type Widget
local move = Widget:new()

node.children = {
	move
}

function node:update(width, height)
	term.setBackgroundColor(colors.white)
	term.clear()
end

function move:update(w, h)
	term.setBackgroundColor(colors.lime)
	term.clear()
end

function node:on(e, key, x, y)
	if e:match "mouse" then
		move.horizontalAlignment = "left"
		move.verticalAlignment = "top"

		if key == 1 then
			move.left = x - 1
			move.top = y - 1
		elseif key == 3 then
			move.width = x - move.left
			move.height = y - move.top
		end
	elseif e == "key" then
		if key == keys.f then
			move.horizontalAlignment = "both"
			move.verticalAlignment = "both"
			move.left = 0
			move.right = 0
			move.top = 0
			move.bottom = 0
		end
	end
end

charmgl.run(charmgl.createFrame(node))