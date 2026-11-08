-- Kurze Rückmeldung oben in der Mitte (z. B. "noch nicht eingerichtet").

local Theme = require(script.Parent:WaitForChild("Theme"))
local C = Theme.C
local px = Theme.udim

local Toast = {}

export type ToastApi = { show: (text: string) -> (), scaler: UIScale, setTouch: (touch: boolean) -> () }

function Toast.build(gui: ScreenGui): ToastApi
	local box = Theme.frame(gui, "Hinweis", UDim2.new(0.5, 0, 0, 16), px(620, 54), C.Navy, Vector2.new(0.5, 0))
	box.Visible = false
	box.ZIndex = 10
	Theme.corner(box, 16)
	Theme.stroke(box, C.Orange, 3)
	local scaler = Theme.scaler(box)
	local label = Theme.text(box, "Text", "", px(16, 9), px(588, 36))
	local token = 0
	return {
		scaler = scaler,
		show = function(text: string)
			token += 1
			local mine = token
			label.Text = text
			box.Visible = true
			task.delay(3, function()
				if token == mine then
					box.Visible = false
				end
			end)
		end,
		setTouch = function(touch: boolean)
			-- auf Touch liegt oben die Instrumentleiste, darunter der Hinweis
			box.Position = if touch then UDim2.new(0.5, 0, 0, 120) else UDim2.new(0.5, 0, 0, 16)
		end,
	}
end

return Toast
