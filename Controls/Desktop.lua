
local Desktop = class(Widget)

function Desktop:on(event, btn, x, y)
	if event == "mouse_drag" and btn == 1 then
		if self.focused and self.focused.dragging then
			local repos = self.focused.style:get "window"
			repos.x = x - self.focused.x_offset
			repos.y = y
		end
	end
end

function Desktop:cycle()
	for i = #self.children, 1, -1 do
		if self.children[i].close then
			table.remove(self.children, i)
		end
	end
end

controls.Desktop = Desktop