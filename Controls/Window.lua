local Window = class(Widget)

function Window:init(x, y, width, height)
	self.st_window = {
		x = x,
		y = y,
		width = width,
		height = height,
		border = colors.gray,
		text = colors.white,
		bar = colors.blue,
		background = colors.white
	}

	self.cmd_close = controls.Button:new() {
		text = string.char(215),
		st_normal = {
			text = colors.white,
			background = colors.red,
		},
		st_pressed = {
			text = colors.lightGray,
			background = colors.orange,
		},
		st_boundaries = {
			horizontalAlignment = "right",
			right = 0
		}
	}

	self.st_cmd_normal = {
		text = colors.white,
		background = colors.lightBlue,
	}

	self.st_cmd_pressed = {
		text = colors.lightGray,
		background = colors.cyan,
	}

	self.cmd_maximize = controls.Button:new() {
		text = "O",
		st_normal = self.st_cmd_normal,
		st_pressed = self.st_cmd_pressed,
		st_boundaries = {
			horizontalAlignment = "right",
			right = 1
		}
	}

	self.cmd_minimize = controls.Button:new() {
		text = "_",
		st_normal = self.st_cmd_normal,
		st_pressed = self.st_cmd_pressed,
		st_boundaries = {
			horizontalAlignment = "right",
			right = 2
		}
	}

	self.maximized = false

	function self.cmd_close.click()
		self:close()
	end

	function self.cmd_maximize.click()
		self:maximize()
	end

	function self.cmd_minimize.click()
		self:minimize()
	end

	self:append(self.cmd_close)
	self:append(self.cmd_minimize)
	self:append(self.cmd_maximize)

	self.title = "Window"
	self.x_offset = 0
	self.dragging = true

	self.style:append("window", self.st_window)
end

function Window:maximize()
	self.maximized = self.maximized == false
end

function Window:minimize()
	self.visible = self.visible == false
	self.minimized = self.visible
end

function Window:close()
	self.closed = true
end

function Window:on(event, btn, x, y)
	if event == "mouse_click" then
		if self.maximized and y == 1 and x <= self.pwidth - 3 then
			self.maximized = false
			self.st_window.x = x - self.x_offset + 1
			self.st_window.y = y
			self.dragging = true
		elseif not self.maximized and not self.resizing then
			self.dragging = y == 1 and btn == 1 and x <= self.style.width - 3

			self.x_offset = x - 1
		end

		if not self.maximized and not self.dragging then
			self.resizing = x == self.style.width and y == self.style.height
		end
	end
end

function Window:bounds(pw, ph)
	self.pwidth = pw

	if self.maximized then
		return {
			x = 1,
			y = 1,
			width = pw,
			height = ph
		}
	end

	local bounds = self.style:get "window"

	return {
		width = bounds.width,
		height = bounds.height,
		x = bounds.x,
		y = bounds.y,
	}
end

function Window:update(width, height)
	term.clear()
	term.setCursorPos(1, 1)
	term.setTextColor(self.style.text)
	term.setBackgroundColor(self.style.bar)
	term.write(self.title .. (" "):rep(width - #self.title))

	term.setTextColor(self.style.background)
	term.setBackgroundColor(self.style.border)

	if not self.maximized then
		term.setCursorPos(2, height)
		term.write(string.char(143):rep(width - 2))
		
		term.setCursorPos(1, height)
		term.write(string.char(138))

		term.setCursorPos(width, height)
		term.write(string.char(133))

		term.setCursorPos(2, height)
		term.setTextColor(self.style.background)
		term.setBackgroundColor(self.style.border)
		term.write(string.char(143):rep(width - 2))

		for y = 2, height - 1 do
			term.setCursorPos(width, y)
			term.setTextColor(self.style.background)
			term.setBackgroundColor(self.style.border)
			term.write(string.char(149))
		end

		for y = 2, height - 1 do
			term.setCursorPos(1, y)
			term.setTextColor(self.style.border)
			term.setBackgroundColor(self.style.background)
			term.write(string.char(149))
		end
	end

	term.setBackgroundColor(self.style.background)
end

controls.Window = Window