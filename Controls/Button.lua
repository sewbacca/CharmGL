
local Button = class(Widget)

function Button:init()
	-- Logic controls

	self.pressed = false
	self.enabled = true
	self.autosize = true
	self.text = "Button"

	-- Style

	self.st_normal = {
		text = colors.white,
		background = colors.lime
	}

	self.st_pressed = {
		text = colors.lightGray,
		background = colors.green
	}

	self.st_disabled = {
		text = colors.lightGray,
		background = colors.gray
	}

	self.st_boundaries.horizontalAlignment = "left"
	self.st_boundaries.verticalAlignment = "top"

	self.style:append("normal", self.st_normal)
end

function Button:cycle()
	if self.autosize then
		local autosize = self.style:get "autosize"

		autosize.width = #self.text
		autosize.height = 1
	else
		self.style:remove "autosize"
	end
end

function Button:on(event, btn, x, y)
	if event:match"mouse" and btn == 1 and self.enabled then
		if event == "mouse_click" then
			self.style:append("pressed", self.st_pressed)
		elseif event == "mouse_up" then
			self.style:remove("pressed")
			
			if self.click then
				self:click()
			end
		end
	end
end

function Button:update()
	if self.enabled == false then
		self.style:append("disabled", self.st_disabled)
	else
		self.style:remove("disabled")
	end

	term.setTextColor(self.style.text)
	term.setBackgroundColor(self.style.background)
	term.clear()
	term.setCursorPos(1, 1)
	term.write(self.text)
end

controls.Button = Button