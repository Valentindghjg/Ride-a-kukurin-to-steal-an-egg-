-- "Meine Eier" (Bild 06): Seitenleiste rechts, die Welt bleibt sichtbar.
-- Je Eiersorte eine Überschrift und Felder mit den gezeichneten Eiern.

local Theme = require(script.Parent:WaitForChild("Theme"))
local C = Theme.C
local px = Theme.udim

local EggPanel = {}

local W, H = 330, 540
local HEADER = 66
local PER_ROW = 3
local SLOT = 88
local SLOT_GAP = 12
local MAX_ROWS_PER_KIND = 1 -- mehr Eier einer Sorte zeigt der Zähler "×n"

export type EggApi = {
	frame: Frame,
	scaler: UIScale,
	open: () -> (),
	close: () -> (),
	isOpen: () -> boolean,
	refresh: (eggs: { [string]: number }) -> (),
}

function EggPanel.build(gui: ScreenGui, kinds: { any }, onHatch: (id: string) -> ()): EggApi
	local panel = Theme.frame(gui, "MeineEier", UDim2.new(1, -16, 0.5, 0), px(W, H), C.Navy, Vector2.new(1, 0.5))
	panel.Visible = false
	panel.ZIndex = 4
	Theme.corner(panel, 20)
	Theme.stroke(panel, C.Outline, 4)
	local scaler = Theme.scaler(panel)

	local header = Theme.frame(panel, "Kopf", px(0, 0), px(W, HEADER), C.Cream)
	Theme.corner(header, 20)
	Theme.gradient(header, C.Cream, C.CreamDark)
	Theme.frame(header, "KopfUnten", px(0, HEADER - 20), px(W, 20), C.CreamDark)
	Theme.text(header, "Titel", "Meine Eier", px(18, 12), px(W - 100, 44), { color = C.Navy, outline = 0, align = Enum.TextXAlignment.Left })
	local close = Theme.closeButton(header, UDim2.new(1, -10, 0.5, 0), Vector2.new(1, 0.5), ">")
	local closeGradient = close:FindFirstChildOfClass("UIGradient")
	if closeGradient then
		closeGradient.Color = ColorSequence.new(C.Orange, C.OrangeDark)
	end

	Theme.text(panel, "Hilfe", "Ei antippen = im Gehege platzieren", px(14, HEADER + 6), px(W - 28, 22), { color = C.GreyDark, outline = 0 })
	-- Liste scrollt, wenn viele Eiersorten zusammenkommen
	local content = Instance.new("ScrollingFrame")
	content.Name = "Liste"
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Position = px(14, HEADER + 34)
	content.Size = px(W - 22, H - HEADER - 44)
	content.ScrollBarThickness = 6
	content.ScrollingDirection = Enum.ScrollingDirection.Y
	content.CanvasSize = px(0, 0)
	content.Parent = panel
	local empty = Theme.text(content, "Leer", "Noch keine Eier.\nHol dir eins im Eiergang!", px(10, 30), px(W - 48, 90), { color = C.GreyDark, outline = 0 })

	local opened = false
	local api: EggApi
	api = {
		frame = panel,
		scaler = scaler,
		open = function()
			opened = true
			panel.Visible = true
		end,
		close = function()
			opened = false
			panel.Visible = false
		end,
		isOpen = function()
			return opened
		end,
		refresh = function(eggs: { [string]: number })
			for _, child in content:GetChildren() do
				if child ~= empty then
					child:Destroy()
				end
			end
			local y = 0
			local any = false
			for _, kind in kinds do
				local count = math.floor(tonumber(eggs[kind.id]) or 0)
				if count > 0 then
					any = true
					local title = Theme.frame(content, "Sorte_" .. kind.id, px(0, y), px(W - 28, 36), C.NavyLight)
					Theme.corner(title, 10)
					local shown = math.min(count, PER_ROW * MAX_ROWS_PER_KIND)
					local label = if count > shown then ("%s  ×%d"):format(kind.name, count) else kind.name
					Theme.text(title, "Name", label, px(12, 4), px(W - 52, 28), { align = Enum.TextXAlignment.Left, outline = 2 })
					y += 44
					for i = 1, shown do
						local col, row = (i - 1) % PER_ROW, math.floor((i - 1) / PER_ROW)
						local slot = Instance.new("TextButton")
						slot.Name = "Feld"
						slot.Text = ""
						slot.AutoButtonColor = true
						slot.BorderSizePixel = 0
						slot.BackgroundColor3 = C.NavyLight
						slot.Position = px(col * (SLOT + SLOT_GAP), y + row * (SLOT + SLOT_GAP))
						slot.Size = px(SLOT, SLOT)
						slot.Parent = content
						Theme.corner(slot, 14)
						Theme.stroke(slot, C.Outline, 2)
						Theme.egg(slot, "Ei", UDim2.fromScale(0.5, 0.52), px(48, 62), kind.schale, kind.punkte, Vector2.new(0.5, 0.5))
						slot.Activated:Connect(function()
							onHatch(kind.id)
						end)
					end
					y += math.ceil(shown / PER_ROW) * (SLOT + SLOT_GAP) + 8
				end
			end
			empty.Visible = not any
			content.CanvasSize = px(0, y)
		end,
	}
	close.Activated:Connect(api.close)
	return api
end

return EggPanel
