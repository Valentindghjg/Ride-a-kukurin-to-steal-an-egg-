-- Gehege: ein Plot je Spieler, Plätze für Tiere, Ausbrüten, Einkommen.
--
-- * Beim Beitritt bekommt jeder Spieler ein freies Plot im Hof (sieben Plots).
-- * Am Eingang steht das Gehegeschild (Bild 08): Besitzer, Belegung und der
--   Preis für den nächsten Platz; "Platz kaufen" kostet Spielgeld.
-- * "Ausbrueten" (aus dem Eierpanel): ein Ei aus "Meine Eier" schlüpft sofort
--   im eigenen Gehege, das Tier steht auf dem nächsten freien Platz und gilt
--   im Tier-Index als entdeckt. Ohne freien Platz bleibt das Ei liegen.
-- * Jede Sekunde wird das Einkommen aller Tiere gutgeschrieben (auch während
--   der Fahrt in der Trainingsstadt), je Rebirth +5 %.
-- Der Stand steht als JSON im Attribut "Gehege"; ändert ein anderer Dienst
-- (Speichern/Laden) das Attribut, baut sich das Gehege daraus neu auf.

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local Katalog = require(shared:WaitForChild("SpielKatalog"))
local A = Config.Attributes

local remotes = ReplicatedStorage:WaitForChild(Config.RemoteFolderName)
local uiAction = remotes:WaitForChild("UIAktion") :: RemoteEvent
local hintEvent = remotes:WaitForChild("Hinweis") :: RemoteEvent

while Workspace:GetAttribute("KukurinMapBereit") ~= true do
	Workspace:GetAttributeChangedSignal("KukurinMapBereit"):Wait()
end
local map = Workspace:WaitForChild("KukurinMap")
local plotsFolder = map:WaitForChild("Gehegehof"):WaitForChild("Plots")
local penFolder = Instance.new("Folder")
penFolder.Name = "Gehege"
penFolder.Parent = map

local function rgb(r: number, g: number, b: number): Color3
	return Color3.fromRGB(r, g, b)
end
local CREAM = rgb(248, 240, 220)
local NAVY = rgb(30, 40, 74)
local ORANGE = rgb(244, 140, 40)
local OUTLINE = rgb(16, 20, 42)
local GREEN = rgb(126, 226, 70)

local function hint(player: Player, text: string)
	hintEvent:FireClient(player, text)
end

local function decode(raw: unknown): any
	if type(raw) ~= "string" then
		return nil
	end
	local ok, value = pcall(HttpService.JSONDecode, HttpService, raw)
	return if ok then value else nil
end

local function money(n: number): string
	local s = tostring(math.floor(n + 0.5))
	return "$" .. (s:reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", ""))
end

---------------------------------------------------------------------------
-- Plots und Plätze
---------------------------------------------------------------------------

type Plot = { index: number, part: BasePart, center: Vector3, top: number }
local plots: { Plot } = {}
for _, part in plotsFolder:GetChildren() do
	if part:IsA("BasePart") and part:GetAttribute("PlotNummer") then
		local top = part.Position.Y + part.Size.Y / 2
		table.insert(plots, { index = part:GetAttribute("PlotNummer"), part = part, center = part.Position, top = top })
	end
end
table.sort(plots, function(a, b)
	return a.index < b.index
end)

-- Platzpositionen relativ zur Plotmitte (zwei Reihen à vier)
local SLOTS = {
	Vector3.new(-15, 0, -6), Vector3.new(-5, 0, -6), Vector3.new(5, 0, -6), Vector3.new(15, 0, -6),
	Vector3.new(-15, 0, 6), Vector3.new(-5, 0, 6), Vector3.new(5, 0, 6), Vector3.new(15, 0, 6),
}

---------------------------------------------------------------------------
-- Modelle: Schild, Platzmarke, Tier
---------------------------------------------------------------------------

local function block(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function label(parent: Instance, text: string, pos: UDim2, size: UDim2, color: Color3): TextLabel
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Position = pos
	l.Size = size
	l.Font = Enum.Font.FredokaOne
	l.TextScaled = true
	l.TextColor3 = color
	l.Text = text
	l.Parent = parent
	return l
end

type Sign = { model: Model, title: { TextLabel }, places: { TextLabel }, offer: { TextLabel }, prompt: ProximityPrompt }

-- Gehegeschild am Eingang (zur Fahrspur, also nach -X gewandt)
local function buildSign(plot: Plot): Sign
	local model = Instance.new("Model")
	model.Name = "Gehegeschild_" .. plot.index
	local base = Vector3.new(plot.center.X - 24.5, plot.top, plot.center.Z)
	for _, dz in { -4.2, 4.2 } do
		block(model, "Pfosten", Vector3.new(0.6, 6.5, 0.6), CFrame.new(base + Vector3.new(0, 3.25, dz)), rgb(120, 80, 50), Enum.Material.Wood)
	end
	local center = base + Vector3.new(0, 6.6, 0)
	local facing = CFrame.lookAt(center, center + Vector3.new(-1, 0, 0))
	block(model, "Rahmen", Vector3.new(10.8, 5.6, 0.5), facing, ORANGE)
	local board = block(model, "Schild", Vector3.new(10, 4.8, 0.7), facing, CREAM)
	local sign: Sign = { model = model, title = {}, places = {}, offer = {}, prompt = nil :: any }
	for _, face in { Enum.NormalId.Front, Enum.NormalId.Back } do
		local gui = Instance.new("SurfaceGui")
		gui.Face = face
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 40
		gui.LightInfluence = 0.2
		gui.Parent = board
		table.insert(sign.title, label(gui, "Freies Gehege", UDim2.fromScale(0.05, 0.04), UDim2.fromScale(0.9, 0.34), NAVY))
		table.insert(sign.places, label(gui, "", UDim2.fromScale(0.08, 0.4), UDim2.fromScale(0.84, 0.26), rgb(60, 66, 90)))
		table.insert(sign.offer, label(gui, "", UDim2.fromScale(0.08, 0.68), UDim2.fromScale(0.84, 0.26), rgb(40, 150, 40)))
	end
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Platz kaufen"
	prompt.ObjectText = "Gehege"
	prompt.HoldDuration = 0.3
	prompt.MaxActivationDistance = 14
	prompt.RequiresLineOfSight = false
	prompt.Enabled = false
	prompt.Parent = board
	sign.prompt = prompt
	model.Parent = penFolder
	return sign
end

-- Blockiges Tier in den Farben seiner Stage, größer bei schwereren Tieren
local function buildAnimal(animal: any, cf: CFrame, parent: Instance): Model
	local stage = Katalog.Stages[animal.stage]
	local s = 0.75 + 0.17 * animal.groesse
	local body = stage.waechter:Lerp(Color3.new(1, 1, 1), 0.3)
	local dark = stage.waechter:Lerp(Color3.new(0, 0, 0), 0.2)
	local model = Instance.new("Model")
	model.Name = animal.id
	local function part(name: string, size: Vector3, offset: Vector3, color: Color3): Part
		return block(model, name, size * s, cf * CFrame.new(offset * s), color)
	end
	local legH = 1.2
	local bodyY = legH + 1
	part("Koerper", Vector3.new(2.4, 2, 3.4), Vector3.new(0, bodyY, 0), body)
	part("Bauch", Vector3.new(2.2, 0.4, 2.6), Vector3.new(0, bodyY - 1.05, 0), stage.punkte)
	part("Kopf", Vector3.new(2, 1.9, 1.9), Vector3.new(0, bodyY + 1, -2.2), body)
	part("Schnauze", Vector3.new(1.2, 0.8, 0.6), Vector3.new(0, bodyY + 0.6, -3.3), dark)
	for _, sx in { -1, 1 } do
		part("Auge", Vector3.new(0.5, 0.5, 0.15), Vector3.new(sx * 0.5, bodyY + 1.35, -3.2), Color3.new(1, 1, 1))
		part("Pupille", Vector3.new(0.25, 0.3, 0.1), Vector3.new(sx * 0.5, bodyY + 1.32, -3.3), rgb(20, 20, 24))
		part("Ohr", Vector3.new(0.5, 0.8, 0.4), Vector3.new(sx * 0.7, bodyY + 2.25, -2), dark)
		for _, z in { -1.1, 1.1 } do
			part("Bein", Vector3.new(0.7, legH, 0.7), Vector3.new(sx * 0.75, legH / 2, z), dark)
		end
	end
	part("Schwanz", Vector3.new(0.5, 0.5, 1.2), Vector3.new(0, bodyY + 0.5, 2.1), dark)

	local head = model:FindFirstChild("Kopf") :: BasePart
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(170, 56)
	gui.StudsOffset = Vector3.new(0, 2.6 * s, 0)
	gui.MaxDistance = 70
	gui.Parent = head
	local name = label(gui, animal.icon .. " " .. animal.name, UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.55), Color3.new(1, 1, 1))
	local nameStroke = Instance.new("UIStroke")
	nameStroke.Color = OUTLINE
	nameStroke.Thickness = 2
	nameStroke.Parent = name
	local income = label(gui, ("+%d $/s"):format(animal.geldProSek), UDim2.fromScale(0.1, 0.55), UDim2.fromScale(0.8, 0.45), GREEN)
	local incomeStroke = Instance.new("UIStroke")
	incomeStroke.Color = OUTLINE
	incomeStroke.Thickness = 2
	incomeStroke.Parent = income
	model.PrimaryPart = model:FindFirstChild("Koerper") :: BasePart
	model.Parent = parent
	return model
end

---------------------------------------------------------------------------
-- Gehege-Zustand je Spieler
---------------------------------------------------------------------------

type Pen = {
	player: Player,
	plot: Plot,
	sign: Sign,
	folder: Folder,
	slots: number,
	animals: { string },
	carry: number, -- Bruchteile von Geld zwischen zwei Gutschriften
	writing: boolean,
}
local pens: { [Player]: Pen } = {}
local signs: { [number]: Sign } = {}
for _, plot in plots do
	signs[plot.index] = buildSign(plot)
end

local function updateSign(plot: Plot, pen: Pen?)
	local sign = signs[plot.index]
	local title, places, offer
	if pen then
		title = pen.player.DisplayName .. "s Gehege"
		places = ("%d / %d Plätze belegt"):format(#pen.animals, pen.slots)
		if pen.slots >= Katalog.Gehege.maxPlaetze then
			offer = "Alle Plätze gekauft"
		else
			offer = ("+1 Platz: %s"):format(money(Katalog.platzPreis(pen.slots)))
		end
		sign.prompt.Enabled = pen.slots < Katalog.Gehege.maxPlaetze
		sign.prompt.ObjectText = if pen.slots < Katalog.Gehege.maxPlaetze then money(Katalog.platzPreis(pen.slots)) else ""
	else
		title, places, offer = "Freies Gehege", "", ""
		sign.prompt.Enabled = false
	end
	for i = 1, #sign.title do
		sign.title[i].Text = title
		sign.places[i].Text = places
		sign.offer[i].Text = offer
	end
end

local function slotCFrame(plot: Plot, i: number): CFrame
	local pos = Vector3.new(plot.center.X, plot.top, plot.center.Z) + SLOTS[i]
	-- Tiere schauen zur Fahrspur
	return CFrame.lookAt(pos, pos + Vector3.new(-1, 0, 0))
end

local function rebuild(pen: Pen)
	pen.folder:ClearAllChildren()
	for i = 1, pen.slots do
		local marker = block(pen.folder, "Platz", Vector3.new(7, 0.1, 7), CFrame.new(Vector3.new(pen.plot.center.X, pen.plot.top + 0.05, pen.plot.center.Z) + SLOTS[i]), CREAM)
		marker.Transparency = 0.35
	end
	for i, id in pen.animals do
		local animal = Katalog.TierNachId[id]
		if animal and SLOTS[i] then
			buildAnimal(animal, slotCFrame(pen.plot, i), pen.folder)
		end
	end
	updateSign(pen.plot, pen)
end

local function incomeOf(pen: Pen): number
	local sum = 0
	for _, id in pen.animals do
		local animal = Katalog.TierNachId[id]
		if animal then
			sum += animal.geldProSek
		end
	end
	local rebirths = pen.player:GetAttribute(A.Rebirths) or 0
	return sum * (1 + rebirths * Katalog.EinkommenJeRebirth)
end

local function save(pen: Pen)
	pen.writing = true
	pen.player:SetAttribute(A.Pen, HttpService:JSONEncode({ plot = pen.plot.index, plaetze = pen.slots, tiere = pen.animals }))
	pen.player:SetAttribute(A.Income, incomeOf(pen))
	pen.writing = false
end

-- Stand aus dem Attribut übernehmen (Beitritt oder geladener Spielstand)
local function loadFromAttribute(pen: Pen)
	local data = decode(pen.player:GetAttribute(A.Pen))
	local slots = Katalog.Gehege.startPlaetze
	local animals = {}
	if type(data) == "table" then
		slots = math.clamp(math.floor(tonumber(data.plaetze) or slots), Katalog.Gehege.startPlaetze, Katalog.Gehege.maxPlaetze)
		if type(data.tiere) == "table" then
			for _, id in data.tiere do
				if Katalog.TierNachId[id] and #animals < slots then
					table.insert(animals, id)
				end
			end
		end
	end
	pen.slots, pen.animals = slots, animals
	rebuild(pen)
	save(pen)
end

local function claim(player: Player)
	if pens[player] then
		return
	end
	local free: Plot? = nil
	for _, plot in plots do
		local taken = false
		for _, pen in pens do
			if pen.plot == plot then
				taken = true
			end
		end
		if not taken then
			free = plot
			break
		end
	end
	if not free then
		hint(player, "Alle Gehege sind belegt. Tritt einem anderen Server bei, um Tiere zu halten.")
		return
	end
	local folder = Instance.new("Folder")
	folder.Name = "Gehege_" .. player.UserId
	folder.Parent = penFolder
	local pen: Pen = {
		player = player,
		plot = free,
		sign = signs[free.index],
		folder = folder,
		slots = Katalog.Gehege.startPlaetze,
		animals = {},
		carry = 0,
		writing = false,
	}
	pens[player] = pen
	loadFromAttribute(pen)
	player:GetAttributeChangedSignal(A.Pen):Connect(function()
		if pens[player] == pen and not pen.writing then
			loadFromAttribute(pen)
		end
	end)
	player:GetAttributeChangedSignal(A.Rebirths):Connect(function()
		if pens[player] == pen then
			save(pen)
		end
	end)
end

local function release(player: Player)
	local pen = pens[player]
	if not pen then
		return
	end
	pens[player] = nil
	pen.folder:Destroy()
	updateSign(pen.plot, nil)
end

Players.PlayerAdded:Connect(claim)
Players.PlayerRemoving:Connect(release)
for _, player in Players:GetPlayers() do
	task.spawn(claim, player)
end

---------------------------------------------------------------------------
-- Platz kaufen und Ausbrüten
---------------------------------------------------------------------------

for _, plot in plots do
	signs[plot.index].prompt.Triggered:Connect(function(player)
		local pen = pens[player]
		if not pen or pen.plot ~= plot then
			hint(player, "Das ist nicht dein Gehege.")
			return
		end
		if pen.slots >= Katalog.Gehege.maxPlaetze then
			return
		end
		local price = Katalog.platzPreis(pen.slots)
		local current = player:GetAttribute(A.Money) or 0
		if current < price then
			hint(player, ("Dir fehlen noch %s für den nächsten Platz."):format(money(price - current)))
			return
		end
		player:SetAttribute(A.Money, current - price)
		pen.slots += 1
		rebuild(pen)
		save(pen)
		hint(player, ("Neuer Platz gekauft! Dein Gehege hat jetzt %d Plätze."):format(pen.slots))
	end)
end

local lastHatch: { [Player]: number } = {}
uiAction.OnServerEvent:Connect(function(player: Player, action: unknown, arg: unknown)
	if action ~= "Ausbrueten" or type(arg) ~= "string" then
		return
	end
	local now = os.clock()
	if (lastHatch[player] or 0) + 0.3 > now then
		return
	end
	lastHatch[player] = now

	local ei = Katalog.EiNachId[arg]
	local pen = pens[player]
	if not ei then
		return
	end
	if not pen then
		hint(player, "Du hast noch kein Gehege.")
		return
	end
	local eggs = decode(player:GetAttribute(A.Eggs))
	if type(eggs) ~= "table" or (tonumber(eggs[arg]) or 0) < 1 then
		return
	end
	if #pen.animals >= pen.slots then
		hint(player, "Dein Gehege ist voll. Kaufe am Gehegeschild einen neuen Platz.")
		return
	end

	eggs[arg] = (tonumber(eggs[arg]) or 0) - 1
	if eggs[arg] <= 0 then
		eggs[arg] = nil
	end
	player:SetAttribute(A.Eggs, HttpService:JSONEncode(eggs))

	local animal = Katalog.TierNachId[ei.tier]
	table.insert(pen.animals, animal.id)
	local index = decode(player:GetAttribute(A.AnimalIndex))
	if type(index) ~= "table" then
		index = {}
	end
	if not table.find(index, animal.id) then
		table.insert(index, animal.id)
		player:SetAttribute(A.AnimalIndex, HttpService:JSONEncode(index))
	end
	rebuild(pen)
	save(pen)
	hint(player, ("%s %s ist geschlüpft! +%d $/s"):format(animal.icon, animal.name, animal.geldProSek))
end)

Players.PlayerRemoving:Connect(function(player)
	lastHatch[player] = nil
end)

---------------------------------------------------------------------------
-- Einkommen: jede Sekunde gutschreiben
---------------------------------------------------------------------------

local elapsed = 0
RunService.Heartbeat:Connect(function(dt)
	elapsed += dt
	if elapsed < 1 then
		return
	end
	local seconds = elapsed
	elapsed = 0
	for player, pen in pens do
		local income = incomeOf(pen)
		if player:GetAttribute(A.Income) ~= income then
			player:SetAttribute(A.Income, income)
		end
		if income > 0 then
			pen.carry += income * seconds
			local whole = math.floor(pen.carry)
			if whole >= 1 then
				pen.carry -= whole
				player:SetAttribute(A.Money, (player:GetAttribute(A.Money) or 0) + whole)
			end
		end
	end
end)
