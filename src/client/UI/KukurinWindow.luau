-- Kukurin-Übersicht (Bild 07): Modellkarten mit echtem 3D-Kukurin, Status
-- (ausgerüstet / ausrüsten / ab Rebirth n) und die Rebirth-Leiste mit
-- Voraussetzung. Vor dem Rebirth zeigt eine Bestätigung Reset und Belohnung.
-- Neue Modelle gibt es nur über den Rebirth, nie per Kauf.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Theme = require(script.Parent:WaitForChild("Theme"))
local Window = require(script.Parent:WaitForChild("Window"))
local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local KukurinModel = require(shared:WaitForChild("KukurinModel"))
local Katalog = require(shared:WaitForChild("SpielKatalog"))
local Training = require(shared:WaitForChild("Training"))
local C = Theme.C
local px = Theme.udim

local KukurinWindow = {}

export type KukurinState = { level: number, rebirths: number, model: string }
export type KukurinApi = {
	window: Window.WindowApi,
	refresh: (state: KukurinState) -> (),
}

-- 3D-Vorschau; gesperrte Modelle als dunkle Silhouette. Gibt eine Funktion
-- zurück, die die Vorschau bei Freischaltung neu aufbaut.
local function preview(parent: Instance, size: Vector2, modelId: string): (boolean) -> ()
	local viewport = Instance.new("ViewportFrame")
	viewport.Name = "Vorschau"
	viewport.BackgroundTransparency = 1
	viewport.AnchorPoint = Vector2.new(0.5, 0)
	viewport.Position = UDim2.new(0.5, 0, 0, 54)
	viewport.Size = px(size.X, size.Y)
	viewport.Ambient = Color3.fromRGB(170, 170, 180)
	viewport.LightColor = Color3.fromRGB(255, 255, 255)
	viewport.LightDirection = Vector3.new(-0.5, -1, -0.4)
	viewport.Parent = parent

	local camera = Instance.new("Camera")
	camera.FieldOfView = 30
	camera.CFrame = CFrame.lookAt(Vector3.new(-9.5, 5.2, -6.5), Vector3.new(0, 2.1, -0.3))
	camera.Parent = viewport
	viewport.CurrentCamera = camera

	local shownLocked: boolean? = nil
	return function(locked: boolean)
		if shownLocked == locked then
			return
		end
		shownLocked = locked
		local old = viewport:FindFirstChildOfClass("Model")
		if old then
			old:Destroy()
		end
		local model = KukurinModel.build(CFrame.new(), modelId)
		for _, d in model:GetDescendants() do
			if d:IsA("BasePart") and locked then
				d.Color = Color3.fromRGB(46, 48, 56)
				d.Material = Enum.Material.SmoothPlastic
			elseif d:IsA("ProximityPrompt") or d:IsA("Light") or (d:IsA("SurfaceGui") and locked) then
				d:Destroy()
			end
		end
		model.Parent = viewport
	end
end

function KukurinWindow.build(gui: ScreenGui, models: { any }, rebirth: any, onEquip: (id: string) -> (), onRebirth: () -> ()): KukurinApi
	local win = Window.create(gui, "KukurinMenue", "Kukurin", "🛴", Vector2.new(800, 560), C.Orange, C.OrangeDark)
	local body = win.body
	local w, h = win.bodySize.X, win.bodySize.Y

	local rebirthH = 92
	local gap = 18
	local cardH = h - rebirthH - 16
	local cardW = math.floor((w - gap * (#models - 1)) / math.max(#models, 1))
	cardW = math.min(cardW, 370)
	local startX = math.floor((w - (cardW * #models + gap * (#models - 1))) / 2)

	type Card = { status: TextButton, statusText: TextLabel, gradient: UIGradient, model: any, setLocked: (boolean) -> () }
	local cards: { Card } = {}
	for i, m in models do
		local card = Theme.frame(body, "Karte_" .. m.id, px(startX + (i - 1) * (cardW + gap), 0), px(cardW, cardH), C.Grey)
		Theme.corner(card, 18)
		Theme.stroke(card, C.GreyDark, 3)
		Theme.gradient(card, C.White, C.Grey)
		local title = m.name
		if (m.tempoBonus or 0) > 0 then
			title ..= (" +%d km/h"):format(m.tempoBonus)
		end
		Theme.text(card, "Name", title, px(16, 10), px(cardW - 32, 42), { outline = 3 })
		local setLocked = preview(card, Vector2.new(cardW - 30, cardH - 140), m.id)
		setLocked(m.rebirth > 0)

		local status = Theme.button(card, "Status", UDim2.new(0.5, 0, 1, -16), px(cardW - 50, 60), C.Green, C.GreenDark, Vector2.new(0.5, 1))
		local statusText = Theme.text(status, "Text", "", px(12, 10), px(cardW - 74, 40))
		local gradient = status:FindFirstChildOfClass("UIGradient") :: UIGradient
		status.Activated:Connect(function()
			onEquip(m.id)
		end)
		table.insert(cards, { status = status, statusText = statusText, gradient = gradient, model = m, setLocked = setLocked })
	end

	-- Rebirth-Leiste
	local bar = Theme.frame(body, "Rebirth", px(0, h - rebirthH), px(w, rebirthH), C.Cream)
	Theme.corner(bar, 16)
	Theme.stroke(bar, C.CreamDark, 3)
	Theme.icon(bar, "Symbol", "🔄", px(16, 14), px(64, 64))
	local barTitle = Theme.text(bar, "Titel", "Rebirth", px(86, 20), px(170, 52), { outline = 3, align = Enum.TextXAlignment.Left })
	Theme.frame(bar, "Trenner", px(262, 16), px(3, rebirthH - 32), C.CreamDark)
	Theme.text(bar, "Zeile1", rebirth.zeile1, px(280, 14), px(260, 30), { color = C.TextDark, outline = 0, align = Enum.TextXAlignment.Left })
	Theme.text(bar, "Zeile2", rebirth.zeile2, px(280, 46), px(260, 30), { color = C.TextDark, outline = 0, align = Enum.TextXAlignment.Left })
	local rebirthButton = Theme.button(bar, "RebirthKnopf", UDim2.new(1, -14, 0.5, 0), px(190, 62), C.Green, C.GreenDark, Vector2.new(1, 0.5))
	local rebirthText = Theme.text(rebirthButton, "Text", "", px(10, 11), px(170, 40))
	local rebirthGradient = rebirthButton:FindFirstChildOfClass("UIGradient") :: UIGradient

	-- Bestätigung: Voraussetzung, Reset und Belohnung
	-- etwas größer als der Inhalt, damit keine Kartenränder hervorschauen
	local confirm = Theme.frame(body, "RebirthBestaetigung", px(-6, -6), px(w + 12, h + 12), C.Navy)
	confirm.ZIndex = 3
	confirm.Visible = false
	Theme.corner(confirm, 14)
	local confirmTitle = Theme.text(confirm, "Titel", "", px(40, 18), px(w - 80, 56), { outline = 3 })
	local confirmReset = Theme.text(confirm, "Reset", "", px(40, 96), px(w - 80, 40), { color = C.Cream, outline = 2 })
	Theme.text(confirm, "Behalten", "Tiere, Geld, Eier und Gehegeplätze bleiben.", px(40, 142), px(w - 80, 36), { color = C.GreyDark, outline = 0 })
	local confirmReward = Theme.text(confirm, "Belohnung", "", px(40, 196), px(w - 80, 80), { color = C.Money, outline = 2 })
	local cancel = Theme.button(confirm, "Abbrechen", px(w / 2 - 230, h - 96), px(210, 64), C.GreyDark, C.Locked)
	Theme.text(cancel, "Text", "Abbrechen", px(14, 12), px(182, 40))
	local go = Theme.button(confirm, "Bestaetigen", px(w / 2 + 20, h - 96), px(210, 64), C.Green, C.GreenDark)
	Theme.text(go, "Text", "Rebirth!", px(14, 12), px(182, 40))

	local state: KukurinState = { level = 1, rebirths = 0, model = models[1].id }
	local function ready(): boolean
		return state.level >= Katalog.rebirthLevel(state.rebirths)
	end

	rebirthButton.Activated:Connect(function()
		if not ready() then
			onRebirth() -- der Server erklärt die Voraussetzung
			return
		end
		local nextNumber = state.rebirths + 1
		confirmTitle.Text = ("Rebirth %d auslösen?"):format(nextNumber)
		confirmReset.Text = ("Speed und Level starten wieder bei Level 1 (%d km/h)."):format(Training.START_SPEED)
		local reward = ("Danach: Training %d %%, Tiereinkommen +%d %%"):format(
			math.floor(Training.multiplier(nextNumber, false) * 100 + 0.5),
			math.floor(nextNumber * Katalog.EinkommenJeRebirth * 100 + 0.5)
		)
		for _, m in models do
			if m.rebirth == nextNumber then
				reward ..= ("\nNeuer Kukurin: %s (+%d km/h)"):format(m.name, m.tempoBonus or 0)
			end
		end
		confirmReward.Text = reward
		confirm.Visible = true
	end)
	cancel.Activated:Connect(function()
		confirm.Visible = false
	end)
	go.Activated:Connect(function()
		confirm.Visible = false
		onRebirth()
	end)
	win.onClose(function()
		confirm.Visible = false
	end)

	local function paint(gradient: UIGradient, top: Color3, bottom: Color3)
		gradient.Color = ColorSequence.new(top, bottom)
	end

	return {
		window = win,
		refresh = function(newState: KukurinState)
			state = newState
			for _, card in cards do
				local m = card.model
				local unlocked = state.rebirths >= m.rebirth
				card.setLocked(not unlocked)
				if state.model == m.id then
					card.statusText.Text = "Ausgerüstet"
					paint(card.gradient, C.Green, C.GreenDark)
				elseif unlocked then
					card.statusText.Text = "Ausrüsten"
					paint(card.gradient, C.Orange, C.OrangeDark)
				else
					card.statusText.Text = ("🔒 Ab Rebirth %d"):format(m.rebirth)
					paint(card.gradient, C.Locked, C.Outline)
				end
			end
			local needed = Katalog.rebirthLevel(state.rebirths)
			barTitle.Text = ("Rebirth %d"):format(state.rebirths + 1)
			if ready() then
				rebirthText.Text = "Rebirth!"
				paint(rebirthGradient, C.Green, C.GreenDark)
			else
				rebirthText.Text = ("Level %d/%d"):format(state.level, needed)
				paint(rebirthGradient, C.GreyDark, C.Locked)
			end
		end,
	}
end

return KukurinWindow
