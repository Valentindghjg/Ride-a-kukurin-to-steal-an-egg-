-- Tier-Index (Bild 05): Raster aller Tiere, unbekannte als Silhouette mit "?".
-- Auswahl eines entdeckten Tiers zeigt rechts Bild, Name und Geld pro Sekunde.
-- Unten der Fortschritt "x / y entdeckt". Mehr als sechs Tiere: Seiten blättern.

local Theme = require(script.Parent:WaitForChild("Theme"))
local Window = require(script.Parent:WaitForChild("Window"))
local C = Theme.C
local px = Theme.udim

local IndexWindow = {}

local COLS, ROWS = 3, 2

export type IndexApi = {
	window: Window.WindowApi,
	refresh: (discovered: { [string]: boolean }) -> (),
}

function IndexWindow.build(gui: ScreenGui, animals: { any }): IndexApi
	local win = Window.create(gui, "TierIndex", "Tier-Index", "📖", Vector2.new(800, 520), C.Cyan, C.CyanDark)
	local body = win.body
	local w, h = win.bodySize.X, win.bodySize.Y

	local footerH = 52
	local gridW = math.floor(w * 0.66)
	local gridH = h - footerH - 14
	local gap = 12

	local gridBack = Theme.frame(body, "Raster", px(0, 0), px(gridW, gridH), C.NavyLight)
	Theme.corner(gridBack, 14)
	local cellW = math.floor((gridW - gap * (COLS + 1)) / COLS)
	local cellH = math.floor((gridH - gap * (ROWS + 1)) / ROWS)

	local detail = Theme.frame(body, "Detail", px(gridW + 14, 0), px(w - gridW - 14, gridH), C.Cream)
	Theme.corner(detail, 14)
	Theme.stroke(detail, C.CreamDark, 3)
	local dw = w - gridW - 14
	local detailIcon = Theme.icon(detail, "Bild", "", UDim2.new(0.5, 0, 0, 20), px(dw - 50, 150), Vector2.new(0.5, 0))
	local detailName = Theme.text(detail, "Name", "", px(10, 182), px(dw - 20, 44), { color = C.White })
	local income = Theme.frame(detail, "Ertrag", UDim2.new(0.5, 0, 0, 238), px(dw - 50, 54), C.Green, Vector2.new(0.5, 0))
	Theme.corner(income, 14)
	Theme.stroke(income, C.Outline, 3)
	Theme.gradient(income, C.Green, C.GreenDark)
	local incomeText = Theme.text(income, "Text", "", px(8, 7), px(dw - 66, 40))
	local emptyText = Theme.text(detail, "Leer", "Wähle ein entdecktes Tier", px(14, 120), px(dw - 28, 60), { color = C.TextDark, outline = 0 })

	local footer = Theme.frame(body, "Fortschritt", px(0, h - footerH), px(w, footerH), C.Cream)
	Theme.corner(footer, 14)
	Theme.stroke(footer, C.CreamDark, 3)
	local badge = Theme.frame(footer, "Abzeichen", px(0, 0), px(96, footerH), C.Cyan)
	Theme.corner(badge, 14)
	Theme.gradient(badge, C.Cyan, C.CyanDark)
	Theme.icon(badge, "Buch", "📖", px(24, 6), px(48, 40))
	local progress = Theme.text(footer, "Text", "", px(110, 8), px(w - 220, 38), { color = C.Navy, outline = 0 })

	-- Seitenknöpfe (nur sichtbar, wenn mehr Tiere als Felder)
	local prev = Theme.button(footer, "Zurueck", px(w - 104, 4), px(44, 44), C.Cyan, C.CyanDark)
	Theme.text(prev, "Pfeil", "<", px(8, 4), px(28, 36))
	local nextB = Theme.button(footer, "Weiter", px(w - 52, 4), px(44, 44), C.Cyan, C.CyanDark)
	Theme.text(nextB, "Pfeil", ">", px(8, 4), px(28, 36))

	type Cell = { button: TextButton, stroke: UIStroke, name: TextLabel, icon: TextLabel, shadow: Frame, question: TextLabel }
	local cells: { Cell } = {}
	for i = 1, COLS * ROWS do
		local col, row = (i - 1) % COLS, math.floor((i - 1) / COLS)
		local b = Instance.new("TextButton")
		b.Name = "Feld" .. i
		b.Text = ""
		b.AutoButtonColor = false
		b.BorderSizePixel = 0
		b.Position = px(gap + col * (cellW + gap), gap + row * (cellH + gap))
		b.Size = px(cellW, cellH)
		b.BackgroundColor3 = C.Cream
		b.Parent = gridBack
		Theme.corner(b, 12)
		local stroke = Theme.stroke(b, C.CreamDark, 3)
		local name = Theme.text(b, "Name", "", px(8, 6), px(cellW - 16, 30))
		local icon = Theme.icon(b, "Bild", "", UDim2.new(0.5, 0, 0, 40), px(cellW - 40, cellH - 52), Vector2.new(0.5, 0))
		local shadow = Theme.frame(b, "Silhouette", UDim2.new(0.5, 0, 0, 56), px(math.floor(cellW * 0.5), math.floor(cellH * 0.42)), C.Silhouette, Vector2.new(0.5, 0))
		Theme.corner(shadow, 18)
		local question = Theme.text(b, "Frage", "?", px(8, 6), px(cellW - 16, 34), { color = C.White })
		table.insert(cells, { button = b, stroke = stroke, name = name, icon = icon, shadow = shadow, question = question })
	end

	local page = 0
	local selected: string? = nil
	local known: { [string]: boolean } = {}
	local perPage = COLS * ROWS
	local pages = math.max(1, math.ceil(#animals / perPage))
	local render: () -> ()

	local function showDetail()
		local animal = nil
		for _, a in animals do
			if a.id == selected and known[a.id] then
				animal = a
			end
		end
		detailIcon.Visible = animal ~= nil
		detailName.Visible = animal ~= nil
		income.Visible = animal ~= nil
		emptyText.Visible = animal == nil
		if animal then
			detailIcon.Text = animal.icon
			detailName.Text = animal.name
			incomeText.Text = ("+%s $/s"):format(Theme.number(animal.geldProSek))
		end
	end

	render = function()
		local count = 0
		for _, a in animals do
			if known[a.id] then
				count += 1
			end
		end
		progress.Text = ("%d / %d entdeckt"):format(count, #animals)
		prev.Visible = pages > 1
		nextB.Visible = pages > 1
		for i, cell in cells do
			local animal = animals[page * perPage + i]
			cell.button.Visible = animal ~= nil
			if animal then
				local isKnown = known[animal.id] == true
				local isSelected = isKnown and selected == animal.id
				cell.button.BackgroundColor3 = if isSelected then C.SelectFill elseif isKnown then C.Cream else C.Unknown
				cell.stroke.Color = if isSelected then C.Select else C.CreamDark
				cell.stroke.Thickness = if isSelected then 5 else 3
				cell.name.Visible = isKnown
				cell.name.Text = animal.name
				cell.icon.Visible = isKnown
				cell.icon.Text = animal.icon
				cell.shadow.Visible = not isKnown
				cell.question.Visible = not isKnown
			end
		end
		showDetail()
	end

	for i, cell in cells do
		cell.button.Activated:Connect(function()
			local animal = animals[page * perPage + i]
			if animal and known[animal.id] then
				selected = animal.id
				render()
			end
		end)
	end
	prev.Activated:Connect(function()
		page = (page - 1) % pages
		render()
	end)
	nextB.Activated:Connect(function()
		page = (page + 1) % pages
		render()
	end)

	return {
		window = win,
		refresh = function(discovered: { [string]: boolean })
			known = discovered
			if not (selected and known[selected]) then
				selected = nil
				for _, a in animals do
					if known[a.id] then
						selected = a.id
						break
					end
				end
			end
			render()
		end,
	}
end

return IndexWindow
