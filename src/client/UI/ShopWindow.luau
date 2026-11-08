-- Robux-Shop (Bild 04): eine Karte pro Artikel mit Wirkung und Robux-Preis.
-- Der Preisknopf führt zur Kaufbestätigung; "Abbrechen" zurück zum Shop,
-- das X zurück ins Spiel. Öffnen und Schließen lösen nie einen Kauf aus.

local Theme = require(script.Parent:WaitForChild("Theme"))
local Window = require(script.Parent:WaitForChild("Window"))
local C = Theme.C
local px = Theme.udim

local ShopWindow = {}

function ShopWindow.build(gui: ScreenGui, items: { any }, onBuy: (id: string) -> ()): Window.WindowApi
	local win = Window.create(gui, "RobuxShop", "Robux-Shop", "🛍️", Vector2.new(780, 470), C.Purple, C.PurpleDark)
	local body = win.body
	local w, h = win.bodySize.X, win.bodySize.Y

	local gap = 20
	local cardW = math.floor((w - gap * (#items - 1)) / math.max(#items, 1))
	cardW = math.min(cardW, 340)
	local startX = math.floor((w - (cardW * #items + gap * (#items - 1))) / 2)
	local cardH = h - 34

	-- Bestätigung (überdeckt die Karten)
	local confirm = Theme.frame(body, "Bestaetigung", px(0, 0), px(w, h), C.Navy)
	confirm.ZIndex = 3
	confirm.Visible = false
	Theme.corner(confirm, 14)
	local confirmText = Theme.text(confirm, "Frage", "", px(40, 70), px(w - 80, 90))
	local cancel = Theme.button(confirm, "Abbrechen", px(w / 2 - 230, 210), px(210, 64), C.GreyDark, C.Locked)
	Theme.text(cancel, "Text", "Abbrechen", px(14, 12), px(182, 40))
	local buy = Theme.button(confirm, "Kaufen", px(w / 2 + 20, 210), px(210, 64), C.Green, C.GreenDark)
	Theme.text(buy, "Text", "Kaufen", px(14, 12), px(182, 40))
	local pending: string? = nil

	cancel.Activated:Connect(function()
		pending = nil
		confirm.Visible = false
	end)
	buy.Activated:Connect(function()
		if pending then
			onBuy(pending)
		end
		pending = nil
		confirm.Visible = false
	end)
	win.onClose(function()
		pending = nil
		confirm.Visible = false
	end)

	for i, item in items do
		local card = Theme.frame(body, "Karte_" .. item.id, px(startX + (i - 1) * (cardW + gap), 0), px(cardW, cardH), C.White)
		Theme.corner(card, 18)
		Theme.stroke(card, C.PurpleEdge, 3)
		Theme.gradient(card, C.PurpleCard, C.PurpleCardDark)

		local titleBox = Theme.frame(card, "Titelfeld", px(24, 12), px(cardW - 48, 44), C.PurpleCardDark)
		Theme.corner(titleBox, 12)
		Theme.stroke(titleBox, C.PurpleEdge, 2)
		Theme.text(titleBox, "Titel", item.name, px(8, 4), px(cardW - 64, 36))

		Theme.icon(card, "Bild", item.icon, UDim2.new(0.5, 0, 0, 72), px(130, 110), Vector2.new(0.5, 0))
		Theme.text(card, "Wirkung", item.text, px(16, cardH - 128), px(cardW - 32, 30), { outline = 2 })

		local price = Theme.button(card, "Preis", UDim2.new(0.5, 0, 1, -18), px(cardW - 60, 64), C.Green, C.GreenDark, Vector2.new(0.5, 1))
		Theme.text(price, "Text", ("%d Robux"):format(item.preis), px(12, 10), px(cardW - 84, 44))
		price.Activated:Connect(function()
			pending = item.id
			confirmText.Text = ("%s für %d Robux kaufen?"):format(item.name, item.preis)
			confirm.Visible = true
		end)
	end

	Theme.text(body, "Hinweis", "Beispielangebote", UDim2.new(0.5, 0, 1, -26), px(260, 24), {
		anchor = Vector2.new(0.5, 0),
		color = C.GreyDark,
		outline = 0,
	})
	return win
end

return ShopWindow
