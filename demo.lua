

local charmgl = require "CharmGL"

local colors = require "CharmGL.aux.colors"

local Document = require "CharmGL.elements.Document"
local Button = require "CharmGL.elements.Button"
local Window = require "CharmGL.elements.Window"
local Box = require "CharmGL.elements.Box"


local app = charmgl.newApp(nil, charmgl.devices.term)

local randtexts = {
	"Hello World",
	"WTF this is happening",
	"It works :D",
	"Your ad could be here..."
}

local n = 0

local restart = false

app.document = Document:new() {
	background = colors.lightBlue;
	onterminate = function()
		app:exit()
	end;
	onkey = function(self, key)
		if key == keys.delete then
			restart = true
			app:exit()
		end
	end,
	children = {
		Button:new() {
			horizontalAlignment = "center";
			verticalAlignment = "center";

			onclick = function(self)
				n = n + 1
				self.text = randtexts[math.random(#randtexts)] .. ' ' .. n
			end;
		},
		Box:new() {
			x = 1,
			y = 1,
			padding = 1,
			growdir = "right",
			children = {
				Button:new() {
					text = "File"
				},
				Button:new() {
					text = "Edit"
				},
				Button:new() {
					text = "Selection"
				},
				Button:new() {
					text = "Terminal"
				}
			}
		},
		Window:new() { y = 3 },
	}
}

app:run()

if restart then
	return shell.run "demo"
end
