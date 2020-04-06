
local Desktop = class(Widget)

function Desktop:on(event, btn, x, y)
	if event == "mouse_drag" and btn == 1 then
		if self.focused then
			local repos = self.focused.style:get "window"
			if self.focused.dragging then
				repos.x = x - self.focused.x_offset
				repos.y = y
			elseif self.focused.resizing then
				repos.width = x - repos.x + 1
				repos.height = y - repos.y + 1
			end
		end
	end
end

function Desktop:cycle()
	for i = #self.children, 1, -1 do
		if self.children[i].closed then
			table.remove(self.children, i)
		end
	end
end

controls.Desktop = Desktop