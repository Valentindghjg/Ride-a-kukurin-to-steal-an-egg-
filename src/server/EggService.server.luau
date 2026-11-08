-- Eier stehlen im Eiergang (Spielkonzept "Eier stehlen im Stage-Gang").
--
-- * In jeder Stage liegen Eier in fünf Größen; die Größe zeigt das Gewicht.
-- * Ein Spieler trägt höchstens ein Ei; es bremst seinen Kukurin (EiTempo).
-- * Jede Stage hat einen Wächter. Er jagt den nächsten Dieb mit einem Ei aus
--   seiner Stage, auch durch fremde Stages (über die Durchgänge), bis zur
--   Safe Zone am EIERGANG-Tor. Spätere Stages haben schnellere Wächter.
-- * Fang: Das Ei kehrt an seinen Platz zurück, der Wächter läuft heim.
-- * Safe Zone erreicht: Das Ei kommt in "Meine Eier", der Platz füllt sich
--   nach einer Weile mit einem neuen Ei.
-- Startwerte stehen in SpielKatalog (Fragen 03, 04, 05).

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
local hintEvent = remotes:WaitForChild("Hinweis") :: RemoteEvent

-- Auf die fertige Map warten
while Workspace:GetAttribute("KukurinMapBereit") ~= true do
	Workspace:GetAttributeChangedSignal("KukurinMapBereit"):Wait()
end
local map = Workspace:WaitForChild("KukurinMap")
local gang = map:WaitForChild("Eiergang")
local SAFE_Z: number = gang:GetAttribute("SafeZ")
local HOF_X: number = gang:GetAttribute("HofHalbeBreite")
local HOF_Z: number = gang:GetAttribute("HofVorne")

type Zone = { index: number, zStart: number, zEnd: number, halfX: number, floor: number, open: number }
local zones: { Zone } = {}
for k = 1, #Katalog.Stages do
	local f = gang:WaitForChild("Stage_" .. k)
	zones[k] = {
		index = k,
		zStart = f:GetAttribute("ZStart"),
		zEnd = f:GetAttribute("ZEnde"),
		halfX = f:GetAttribute("HalbeBreite"),
		floor = f:GetAttribute("Boden"),
		open = f:GetAttribute("Durchgang"),
	}
end

local eggFolder = Instance.new("Folder")
eggFolder.Name = "Eier"
eggFolder.Parent = map
local guardFolder = Instance.new("Folder")
guardFolder.Name = "Waechter"
guardFolder.Parent = map

local function hint(player: Player, text: string)
	hintEvent:FireClient(player, text)
end

local function rootOf(player: Player): BasePart?
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		return root
	end
	return nil
end

-- 0 = Hof (Safe Zone), 1..n = Stage-Zone (Mauer zählt zur vorderen Zone)
local function zoneOf(z: number): number
	if z > SAFE_Z then
		return 0
	end
	for k, zone in zones do
		if z >= zone.zEnd - 6 then
			return k
		end
	end
	return #zones
end

local function inSafeZone(pos: Vector3): boolean
	return pos.Z > SAFE_Z and pos.Z < HOF_Z + 10 and math.abs(pos.X) < HOF_X + 10
end

---------------------------------------------------------------------------
-- Ei-Modell
---------------------------------------------------------------------------

local function sphere(name: string, size: Vector3, cf: CFrame, color: Color3, parent: Instance): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Sphere
	mesh.Parent = p
	p.Parent = parent
	return p
end

-- Ei als Ellipsoid mit Punkten. Ursprung = Mitte des Eis.
local function buildEgg(ei: any, withLabel: boolean): Model
	local model = Instance.new("Model")
	model.Name = ei.id
	local w = 2.2 * ei.skala
	local h = w * 1.3
	local shell = sphere("Schale", Vector3.new(w, h, w), CFrame.new(), ei.schale, model)
	model.PrimaryPart = shell
	local dots = { { 0, 0.35 }, { 72, -0.1 }, { 144, 0.45 }, { 216, 0.05 }, { 288, -0.35 }, { 30, -0.55 }, { 200, 0.6 } }
	for _, d in dots do
		local theta, lat = math.rad(d[1]), d[2]
		local c = math.cos(math.asin(lat))
		-- Punkt tief in die Schale setzen, damit nur ein flacher Tupfen herausschaut
		local pos = Vector3.new(w / 2 * c * math.cos(theta), h / 2 * lat, w / 2 * c * math.sin(theta)) * 0.86
		sphere("Punkt", Vector3.new(w * 0.3, w * 0.3, w * 0.3), CFrame.new(pos), ei.punkte, model)
	end
	if ei.groesse >= 4 then
		local glow = Instance.new("PointLight")
		glow.Color = ei.punkte
		glow.Range = 10
		glow.Brightness = 1.5
		glow.Parent = shell
	end
	if withLabel then
		local gui = Instance.new("BillboardGui")
		gui.Size = UDim2.fromOffset(220, 44)
		gui.StudsOffset = Vector3.new(0, h / 2 + 1.6, 0)
		gui.MaxDistance = 80
		gui.Parent = shell
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.FredokaOne
		label.Text = ei.name
		label.TextScaled = true
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Parent = gui
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 2
		stroke.Color = Color3.fromRGB(16, 20, 42)
		stroke.Parent = label
	end
	return model
end

---------------------------------------------------------------------------
-- Eierplätze
---------------------------------------------------------------------------

-- Plätze je Zone: x und Anteil der Tiefe (weg von Weg und Deko)
local SPOTS = { { -20, 0.3 }, { 20, 0.3 }, { -34, 0.55 }, { 34, 0.55 }, { -22, 0.82 }, { 22, 0.82 } }

type Spot = { zone: number, pos: Vector3, ei: any?, egg: Model?, respawnAt: number? }
local spots: { Spot } = {}

local function randomEgg(stage: number): any
	local total = 0
	for _, g in Katalog.Groessen do
		total += g.haeufigkeit
	end
	local roll = math.random() * total
	for i, g in Katalog.Groessen do
		roll -= g.haeufigkeit
		if roll <= 0 then
			return Katalog.EiNachId[Katalog.Stages[stage].id .. i]
		end
	end
	return Katalog.EiNachId[Katalog.Stages[stage].id .. "1"]
end

type Carry = { ei: any, spot: Spot, visual: Model? }
local carrying: { [Player]: Carry } = {}

local take: (Player, Spot) -> ()

local function placeEgg(spot: Spot, ei: any)
	if spot.egg then
		spot.egg:Destroy()
	end
	local model = buildEgg(ei, true)
	local h = 2.2 * ei.skala * 1.3
	model:PivotTo(CFrame.new(spot.pos + Vector3.new(0, h / 2, 0)) * CFrame.Angles(0, math.random() * math.pi * 2, 0))
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Ei nehmen"
	prompt.ObjectText = ei.name
	prompt.HoldDuration = 0.35
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = model.PrimaryPart
	prompt.Triggered:Connect(function(player)
		take(player, spot)
	end)
	model.Parent = eggFolder
	spot.ei, spot.egg, spot.respawnAt = ei, model, nil
end

for k, zone in zones do
	for _, s in SPOTS do
		local spot: Spot = {
			zone = k,
			pos = Vector3.new(s[1], zone.floor, zone.zStart - s[2] * (zone.zStart - zone.zEnd)),
			ei = nil,
			egg = nil,
			respawnAt = nil,
		}
		table.insert(spots, spot)
		placeEgg(spot, randomEgg(k))
	end
end

---------------------------------------------------------------------------
-- Tragen, Abgeben, Verlieren
---------------------------------------------------------------------------

local function setCarryAttributes(player: Player, ei: any?)
	player:SetAttribute(A.CarryEgg, if ei then ei.id else nil)
	player:SetAttribute(A.CarrySpeed, if ei then ei.tempo else nil)
end

local function attachVisual(player: Player, ei: any): Model?
	local root = rootOf(player)
	if not root then
		return nil
	end
	local model = buildEgg(ei, false)
	model.Name = "GetragenesEi"
	model:PivotTo(root.CFrame * CFrame.new(0, 0.7, 1.6))
	for _, part in model:GetDescendants() do
		if part:IsA("BasePart") then
			part.Anchored = false
			part.Massless = true
			if part ~= model.PrimaryPart then
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = model.PrimaryPart
				weld.Part1 = part
				weld.Parent = part
			end
		end
	end
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = model.PrimaryPart
	weld.Parent = model.PrimaryPart
	model.Parent = player.Character
	return model
end

-- reason: "geliefert" (neues Ei später), sonst kehrt das Ei an seinen Platz zurück
local function release(player: Player, reason: string)
	local carry = carrying[player]
	if not carry then
		return
	end
	carrying[player] = nil
	if carry.visual then
		carry.visual:Destroy()
	end
	setCarryAttributes(player, nil)
	if reason == "geliefert" then
		carry.spot.respawnAt = os.clock() + Katalog.EiNachschub
	else
		placeEgg(carry.spot, carry.ei)
	end
end

take = function(player: Player, spot: Spot)
	if carrying[player] then
		hint(player, "Du trägst schon ein Ei. Bring es erst in den Hof!")
		return
	end
	local root = rootOf(player)
	if not (root and spot.egg and spot.ei) then
		return
	end
	if (root.Position - spot.egg:GetPivot().Position).Magnitude > 18 then
		return
	end
	local ei = spot.ei
	spot.egg:Destroy()
	spot.egg, spot.ei = nil, nil
	carrying[player] = { ei = ei, spot = spot, visual = attachVisual(player, ei) }
	setCarryAttributes(player, ei)
	hint(player, ("%s geschnappt! Schnell zurück in den Hof!"):format(ei.name))
end

local function decodeEggs(player: Player): { [string]: number }
	local raw = player:GetAttribute(A.Eggs)
	if type(raw) ~= "string" then
		return {}
	end
	local ok, value = pcall(HttpService.JSONDecode, HttpService, raw)
	return if ok and type(value) == "table" then value else {}
end

local function deliver(player: Player)
	local carry = carrying[player]
	if not carry then
		return
	end
	local eggs = decodeEggs(player)
	eggs[carry.ei.id] = (tonumber(eggs[carry.ei.id]) or 0) + 1
	player:SetAttribute(A.Eggs, HttpService:JSONEncode(eggs))
	hint(player, carry.ei.name .. " ist in Sicherheit! Du findest es unter \"Meine Eier\".")
	release(player, "geliefert")
end

Players.PlayerRemoving:Connect(function(player)
	release(player, "verloren")
end)
local function watchCharacter(player: Player)
	player.CharacterRemoving:Connect(function()
		release(player, "verloren")
	end)
end
Players.PlayerAdded:Connect(watchCharacter)
for _, player in Players:GetPlayers() do
	watchCharacter(player)
end

---------------------------------------------------------------------------
-- Wächter
---------------------------------------------------------------------------

type Guard = {
	stage: number,
	root: BasePart,
	pos: Vector3,
	home: Vector3,
	yaw: number,
	speed: number,
	target: Player?,
	hop: number,
}
local guards: { Guard } = {}

local function guardPart(model: Model, root: BasePart?, name: string, size: Vector3, offset: CFrame, color: Color3): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if root then
		p.Anchored = false
		p.Massless = true
		p.CFrame = root.CFrame * offset
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = root
		weld.Part1 = p
		weld.Parent = p
	else
		p.Anchored = true
		p.CFrame = offset
	end
	p.Parent = model
	return p
end

-- Blockiger Wächter in der Farbe seiner Stage. Ursprung = Mitte zwischen den Füßen.
local function buildGuard(stage: any, pos: Vector3): (Model, BasePart)
	local model = Instance.new("Model")
	model.Name = "Waechter_" .. stage.id
	local dark = stage.waechter:Lerp(Color3.new(0, 0, 0), 0.35)
	local root = guardPart(model, nil, "Koerper", Vector3.new(5, 4.4, 7), CFrame.new(pos + Vector3.new(0, 4.6, 0)), stage.waechter)
	model.PrimaryPart = root
	guardPart(model, root, "Kopf", Vector3.new(4.4, 4, 4), CFrame.new(0, 2.2, -4.2), stage.waechter)
	guardPart(model, root, "Schnauze", Vector3.new(2.6, 1.6, 1.4), CFrame.new(0, 1.2, -6.8), dark)
	for _, s in { -1, 1 } do
		guardPart(model, root, "Auge", Vector3.new(1.1, 1.1, 0.3), CFrame.new(s * 1.1, 2.9, -6.25), Color3.new(1, 1, 1))
		guardPart(model, root, "Pupille", Vector3.new(0.5, 0.6, 0.2), CFrame.new(s * 1.1, 2.8, -6.45), Color3.fromRGB(20, 20, 24))
		guardPart(model, root, "Braue", Vector3.new(1.3, 0.35, 0.3), CFrame.new(s * 1.1, 3.65, -6.3) * CFrame.Angles(0, 0, s * math.rad(-18)), dark)
		guardPart(model, root, "Ohr", Vector3.new(1, 1.6, 0.8), CFrame.new(s * 1.6, 4.9, -4) * CFrame.Angles(0, 0, s * math.rad(-12)), dark)
		for _, z in { -2.4, 2.4 } do
			guardPart(model, root, "Bein", Vector3.new(1.4, 2.6, 1.4), CFrame.new(s * 1.6, -3.3, z), dark)
		end
	end
	guardPart(model, root, "Schwanz", Vector3.new(1, 1, 2.6), CFrame.new(0, 1.2, 4.4) * CFrame.Angles(math.rad(30), 0, 0), dark)

	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(240, 40)
	gui.StudsOffset = Vector3.new(0, 6.5, 0)
	gui.MaxDistance = 120
	gui.Parent = root
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.FredokaOne
	label.Text = stage.waechterName
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(255, 90, 80)
	label.Parent = gui
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(16, 20, 42)
	stroke.Parent = label

	model.Parent = guardFolder
	return model, root
end

for k, zone in zones do
	local stage = Katalog.Stages[k]
	local home = Vector3.new(0, zone.floor, (zone.zStart + zone.zEnd) / 2)
	local _, root = buildGuard(stage, home)
	table.insert(guards, {
		stage = k,
		root = root,
		pos = home,
		home = home,
		yaw = 0,
		speed = Katalog.Waechter.tempoStart + (k - 1) * Katalog.Waechter.tempoJeStage,
		target = nil,
		hop = 0,
	})
end

-- Nächster Dieb mit einem Ei aus dieser Stage, der noch nicht im Hof ist
local function chooseTarget(guard: Guard): Player?
	local best, bestDistance = nil, math.huge
	for player, carry in carrying do
		local root = rootOf(player)
		if carry.ei.stage == guard.stage and root and not inSafeZone(root.Position) then
			local d = (root.Position - guard.pos).Magnitude
			if d < bestDistance then
				best, bestDistance = player, d
			end
		end
	end
	return best
end

-- Nächster Wegpunkt: im selben Abschnitt direkt, sonst über den Durchgang
local function waypoint(guard: Guard, goal: Vector3): Vector3
	local gz, tz = zoneOf(guard.pos.Z), zoneOf(goal.Z)
	if tz == 0 then
		tz = 1 -- Ziel im Hof: höchstens bis an das Tor
	end
	if gz == 0 then
		gz = 1
	end
	local zone = zones[gz]
	if gz == tz then
		-- Nach einem Durchgang erst aus dem Mauerbereich heraus, dann seitlich
		local inGap = math.abs(guard.pos.X) < zone.open
		if inGap and guard.pos.Z > zone.zStart - 5 and goal.Z < zone.zStart - 5 then
			return Vector3.new(guard.pos.X, zone.floor, zone.zStart - 7)
		end
		if inGap and guard.pos.Z < zone.zEnd + 5 and goal.Z > zone.zEnd + 5 then
			return Vector3.new(guard.pos.X, zone.floor, zone.zEnd + 7)
		end
		local x = math.clamp(goal.X, -zone.halfX + 4, zone.halfX - 4)
		local z = math.clamp(goal.Z, zone.zEnd + 4, zone.zStart - 2)
		return Vector3.new(x, zone.floor, z)
	end
	local towardHof = tz < gz
	local wallZ = if towardHof then zone.zStart + 3 else zone.zEnd - 3
	local side = if towardHof then -1 else 1 -- Seite des Wächters vor der Mauer
	local front = Vector3.new(0, zone.floor, wallZ + side * 9)
	local beyond = Vector3.new(0, zone.floor, wallZ - side * 9)
	local inDoorway = math.abs(guard.pos.X) < zone.open - 3 and math.abs(guard.pos.Z - wallZ) < 9.5
	if inDoorway then
		return beyond
	end
	return front
end

local function moveGuard(guard: Guard, dt: number)
	local target = chooseTarget(guard)
	guard.target = target
	local goal = guard.home
	local targetRoot = target and rootOf(target)
	if targetRoot then
		goal = targetRoot.Position
	end

	local wp = waypoint(guard, goal)
	local delta = Vector3.new(wp.X - guard.pos.X, 0, wp.Z - guard.pos.Z)
	local distance = delta.Magnitude
	local speed = if target then guard.speed else guard.speed * 0.6
	if distance > 0.5 then
		local step = math.min(speed * dt, distance)
		guard.pos += delta.Unit * step
		guard.yaw = math.atan2(-delta.X, -delta.Z)
		guard.hop += dt * (if target then 14 else 8)
	else
		guard.hop = 0
	end
	local bounce = math.abs(math.sin(guard.hop)) * (if distance > 0.5 then 0.8 else 0)
	guard.root.CFrame = CFrame.new(guard.pos + Vector3.new(0, 4.6 + bounce, 0)) * CFrame.Angles(0, guard.yaw, 0)

	-- Fang
	if target and targetRoot then
		local flat = Vector3.new(targetRoot.Position.X - guard.pos.X, 0, targetRoot.Position.Z - guard.pos.Z)
		if flat.Magnitude < Katalog.Waechter.fangAbstand then
			release(target, "gefangen")
			hint(target, ("Erwischt! Der %s hat dir das Ei abgenommen."):format(Katalog.Stages[guard.stage].waechterName))
		end
	end
end

---------------------------------------------------------------------------
-- Takt: Wächter bewegen, Abgaben prüfen, Eier nachlegen
---------------------------------------------------------------------------

local checkTimer = 0
RunService.Heartbeat:Connect(function(dt)
	for _, guard in guards do
		moveGuard(guard, dt)
	end

	checkTimer += dt
	if checkTimer < 0.2 then
		return
	end
	checkTimer = 0
	for player in carrying do
		local root = rootOf(player)
		if root and inSafeZone(root.Position) then
			deliver(player)
		end
	end
	local now = os.clock()
	for _, spot in spots do
		if spot.respawnAt and now >= spot.respawnAt then
			placeEgg(spot, randomEgg(spot.zone))
		end
	end
end)
