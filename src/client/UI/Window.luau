-- Mittiges Menüfenster (Bilder 04, 05, 07): dunkler Körper, farbiger Kopf mit
-- Titel und rotem X. Die Spielwelt bleibt rundherum sichtbar.

local TweenService = game:GetService("TweenService")

local Theme = require(script.Parent:WaitForChild("Theme"))
local C = Theme.C
local px = Theme.udim

local Window = {}

local HEADER = 70
local PAD = 16

export type WindowApi = {
	frame: Frame,
	body: Frame, -- Inhaltsfläche unter dem Kopf
	bodySize: Vector2,
	scaler: UIScale,
	pop: UIScale,
	open: () -> (),
	close: () -> (),
	isOpen: () -> boolean,
	onClose: ((() -> ()) -> ()),
}

function Window.create(gui: ScreenGui, name: string, title: string, icon: string?, size: Vector2, top: Color3, bottom: Color3): WindowApi
	local frame = Theme.frame(gui, name, UDim2.fromScale(0.5, 0.5), px(size.X, size.Y), C.Navy, Vector2.new(0.5, 0.5))
	frame.Visible = false
	frame.ZIndex = 5
	Theme.corner(frame, 20)
	Theme.stroke(frame, C.Outline, 4)
	local scaler = Theme.scaler(frame)
	-- zweite Skalierung nur für die Aufklapp-Animation
	local holder = Theme.group(frame, "Inhalt", UDim2.fromScale(0.5, 0.5), UDim2.fromScale(1, 1), Vector2.new(0.5, 0.5))
	local pop = Instance.new("UIScale")
	pop.Name = "Aufklappen"
	pop.Parent = holder

	local header = Theme.frame(holder, "Kopf", px(0, 0), UDim2.new(1, 0, 0, HEADER), C.White)
	Theme.corner(header, 20)
	Theme.gradient(header, top, bottom)
	-- unterer Rand des Kopfes gerade
	local headerFoot = Theme.frame(header, "KopfUnten", UDim2.new(0, 0, 1, -20), UDim2.new(1, 0, 0, 20), C.White)
	Theme.gradient(headerFoot, bottom:Lerp(top, 0.25), bottom)
	local titleX = 22
	if icon then
		Theme.icon(header, "Symbol", icon, px(16, 10), px(50, 50))
		titleX = 72
	end
	Theme.text(header, "Titel", title, px(titleX, 12), px(size.X - titleX - 90, 46), { align = Enum.TextXAlignment.Left, outline = 3 })
	local closeButton = Theme.closeButton(header, UDim2.new(1, -14, 0.5, 0), Vector2.new(1, 0.5))

	local bodySize = Vector2.new(size.X - PAD * 2, size.Y - HEADER - PAD * 2)
	local body = Theme.group(holder, "Koerper", px(PAD, HEADER + PAD), px(bodySize.X, bodySize.Y))

	local closeListeners: { () -> () } = {}
	local opened = false
	local api: WindowApi
	api = {
		frame = frame,
		body = body,
		bodySize = bodySize,
		scaler = scaler,
		pop = pop,
		open = function()
			if opened then
				return
			end
			opened = true
			frame.Visible = true
			pop.Scale = 0.85
			TweenService:Create(pop, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		end,
		close = function()
			if not opened then
				return
			end
			opened = false
			frame.Visible = false
			for _, listener in closeListeners do
				listener()
			end
		end,
		isOpen = function()
			return opened
		end,
		onClose = function(listener: () -> ())
			table.insert(closeListeners, listener)
		end,
	}
	closeButton.Activated:Connect(api.close)
	return api
end

return Window
