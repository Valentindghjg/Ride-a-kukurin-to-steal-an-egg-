-- Fahransicht (Bild 02): links drei Menüknöpfe, rechts der Eier-Knopf,
-- unten links das Instrument mit km/h und Geld.
-- Levelleiste wie die Minecraft-Erfahrungsleiste: lang und schmal unten in
-- der Mitte, darüber links "Level n", rechts was bis zum nächsten Level fehlt.
-- Auf Touch-Geräten wird das Instrument zur schmalen Leiste oben (Bild 05),
-- weil unten links der Joystick liegt.

local Theme = require(script.Parent:WaitForChild("Theme"))
local C = Theme.C
local px = Theme.udim

local Hud = {}

export type HudApi = {
	setSpeed: (kmh: number) -> (),
	setLevel: (level: number, training: number, toNextKmh: number?) -> (),
	setMoney: (money: number) -> (),
	setWheelie: (active: boolean) -> (),
	setTouch: (touch: boolean) -> (),
	scalers: { UIScale },
}

local MENU = {
	{ id = "Kukurin", text = "Kukurin", icon = "🛴", top = C.Orange, bottom = C.OrangeDark },
	{ id = "TierIndex", text = "Tier-Index", icon = "📖", top = C.Cyan, bottom = C.CyanDark },
	{ id = "Shop", text = "Robux-Shop", icon = "🛍️", top = C.Purple, bottom = C.PurpleDark },
}

local LEVEL_W = 560 -- Breite der Levelleiste
local LEVEL_BAR_H = 20
local LEVEL_SEGMENTS = 18

function Hud.build(gui: ScreenGui, onMenu: (id: string) -> (), onEggs: () -> ()): HudApi
	local scalers = {}

	-- Menüknöpfe links
	local menu = Theme.group(gui, "Menuetasten", UDim2.new(0, 16, 0.5, 0), px(244, 214), Vector2.new(0, 0.5))
	table.insert(scalers, Theme.scaler(menu))
	for i, entry in MENU do
		local b = Theme.button(menu, entry.id, px(0, (i - 1) * 76), px(240, 62), entry.top, entry.bottom)
		Theme.icon(b, "Symbol", entry.icon, px(10, 8), px(46, 46))
		Theme.text(b, "Text", entry.text, px(62, 11), px(168, 40), { align = Enum.TextXAlignment.Left })
		b.Activated:Connect(function()
			onMenu(entry.id)
		end)
	end

	-- Eier-Knopf rechts
	local eggButton = Theme.button(gui, "EierKnopf", UDim2.new(1, -16, 0.5, 0), px(76, 76), C.Orange, C.OrangeDark, Vector2.new(1, 0.5))
	table.insert(scalers, Theme.scaler(eggButton))
	Theme.egg(eggButton, "Ei", UDim2.fromScale(0.5, 0.52), px(40, 52), C.Cream, C.Orange, Vector2.new(0.5, 0.5))
	eggButton.Activated:Connect(onEggs)

	-- Instrument (PC): Tempo und Geld unten links
	local panel = Theme.frame(gui, "Instrument", UDim2.new(0, 16, 1, -16), px(290, 100), C.Navy, Vector2.new(0, 1))
	table.insert(scalers, Theme.scaler(panel))
	Theme.corner(panel, 18)
	Theme.stroke(panel, C.Orange, 3)
	Theme.gradient(panel, C.NavyLight, C.Navy)
	Theme.icon(panel, "Scooter", "🛴", px(12, 6), px(46, 42))
	local speedPc = Theme.text(panel, "Tempo", "0 km/h", px(64, 8), px(214, 40), { align = Enum.TextXAlignment.Left })
	Theme.icon(panel, "Geldschein", "💵", px(10, 52), px(46, 42))
	local moneyPc = Theme.text(panel, "Geld", "$0", px(62, 54), px(214, 40), { color = C.Money, align = Enum.TextXAlignment.Left })

	-- Leiste (Touch): Tempo und Geld oben in der Mitte
	local strip = Theme.frame(gui, "Instrumentleiste", UDim2.new(0.5, 0, 0, 8), px(380, 58), C.Navy, Vector2.new(0.5, 0))
	table.insert(scalers, Theme.scaler(strip))
	Theme.corner(strip, 16)
	Theme.stroke(strip, C.Orange, 3)
	Theme.gradient(strip, C.NavyLight, C.Navy)
	Theme.icon(strip, "Scooter", "🛴", px(10, 7), px(44, 44))
	local speedTouch = Theme.text(strip, "Tempo", "0 km/h", px(56, 12), px(134, 34), { align = Enum.TextXAlignment.Left })
	Theme.frame(strip, "Trenner", px(196, 10), px(3, 38), C.BarBack)
	local moneyTouch = Theme.text(strip, "Geld", "$0", px(212, 10), px(156, 38), { color = C.Money, align = Enum.TextXAlignment.Left })

	-- Levelleiste unten in der Mitte (wie die Minecraft-Erfahrungsleiste)
	local levelGroup = Theme.group(gui, "Levelleiste", UDim2.new(0.5, 0, 1, -12), px(LEVEL_W, 34 + LEVEL_BAR_H), Vector2.new(0.5, 1))
	table.insert(scalers, Theme.scaler(levelGroup))
	local levelText = Theme.text(levelGroup, "Level", "Level 1", px(2, 0), px(220, 30), { align = Enum.TextXAlignment.Left, outline = 3 })
	local nextText = Theme.text(levelGroup, "BisNaechstes", "", px(LEVEL_W - 322, 3), px(320, 26), {
		align = Enum.TextXAlignment.Right,
		color = C.Cream,
		outline = 2.5,
	})
	local back = Theme.frame(levelGroup, "Hintergrund", px(0, 34), px(LEVEL_W, LEVEL_BAR_H), C.BarBack)
	Theme.corner(back, 6)
	Theme.stroke(back, C.Outline, 3)
	local fill = Theme.frame(back, "Fuellung", px(0, 0), UDim2.fromScale(0, 1), C.Orange)
	Theme.corner(fill, 6)
	Theme.gradient(fill, C.Orange, C.OrangeDark)
	local shine = Theme.frame(fill, "Glanz", px(4, 3), UDim2.new(1, -8, 0, 4), C.White)
	shine.BackgroundTransparency = 0.55
	Theme.round(shine)
	for i = 1, LEVEL_SEGMENTS - 1 do
		local tick = Theme.frame(back, "Segment", UDim2.new(i / LEVEL_SEGMENTS, -1, 0, 2), UDim2.new(0, 2, 1, -4), C.Outline)
		tick.BackgroundTransparency = 0.35
		tick.ZIndex = 2
	end

	-- Wheelie-Bonus (Bild 03) über dem Instrument
	local wheelie = Theme.frame(gui, "WheelieBonus", UDim2.new(0, 16, 1, -126), px(210, 40), C.Orange, Vector2.new(0, 1))
	table.insert(scalers, Theme.scaler(wheelie))
	Theme.corner(wheelie, 12)
	Theme.stroke(wheelie, C.Outline, 3)
	Theme.gradient(wheelie, C.Orange, C.OrangeDark)
	Theme.text(wheelie, "Text", "⬆ Wheelie-Bonus", px(10, 6), px(190, 28))
	wheelie.Visible = false

	local touchMode = false
	local api: HudApi = {
		scalers = scalers,
		setSpeed = function(kmh: number)
			local text = ("%d km/h"):format(math.floor(kmh + 0.5))
			speedPc.Text = text
			speedTouch.Text = text
		end,
		setLevel = function(level: number, training: number, toNextKmh: number?)
			levelText.Text = "Level " .. level
			fill.Size = UDim2.fromScale(math.clamp(training, 0, 1), 1)
			if toNextKmh and toNextKmh > 0 then
				nextText.Text = ("noch %s km/h bis Level %d"):format(Theme.number(toNextKmh), level + 1)
				nextText.Visible = true
			else
				nextText.Visible = false
			end
		end,
		setMoney = function(money: number)
			local text = "$" .. Theme.number(money)
			moneyPc.Text = text
			moneyTouch.Text = text
		end,
		setWheelie = function(active: boolean)
			wheelie.Visible = active
		end,
		setTouch = function(touch: boolean)
			touchMode = touch
			panel.Visible = not touch
			strip.Visible = touch
			wheelie.Position = if touch then UDim2.new(0.5, 0, 0, 74) else UDim2.new(0, 16, 1, -126)
			wheelie.AnchorPoint = if touch then Vector2.new(0.5, 0) else Vector2.new(0, 1)
		end,
	}
	api.setTouch(touchMode)
	return api
end

return Hud
