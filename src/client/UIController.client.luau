-- Baut die Oberfläche und befüllt sie aus den Spielerdaten (Attribute am
-- Spieler, vom Server gesetzt). Ein Menüfenster ist höchstens einmal offen;
-- das Eierpanel ist unabhängig davon. Alle Käufe, Ausrüsten und Rebirth
-- laufen als Anfrage an den Server ("UIAktion"), Rückmeldungen kommen als
-- Hinweis zurück.

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local Katalog = require(shared:WaitForChild("SpielKatalog"))
local A = Config.Attributes

local ui = script.Parent:WaitForChild("UI")
local Theme = require(ui:WaitForChild("Theme"))
local Hud = require(ui:WaitForChild("Hud"))
local ShopWindow = require(ui:WaitForChild("ShopWindow"))
local IndexWindow = require(ui:WaitForChild("IndexWindow"))
local KukurinWindow = require(ui:WaitForChild("KukurinWindow"))
local EggPanel = require(ui:WaitForChild("EggPanel"))
local Toast = require(ui:WaitForChild("Toast"))

local remotes = ReplicatedStorage:WaitForChild(Config.RemoteFolderName)
local uiAction = remotes:WaitForChild("UIAktion") :: RemoteEvent
local hintEvent = remotes:WaitForChild("Hinweis") :: RemoteEvent

local gui = Instance.new("ScreenGui")
gui.Name = "KukurinUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local toast = Toast.build(gui)
local shop = ShopWindow.build(gui, Katalog.Shop, function(id)
	uiAction:FireServer("Kaufen", id)
end)
local index = IndexWindow.build(gui, Katalog.Tiere)
local kukurin = KukurinWindow.build(gui, Katalog.Modelle, Katalog.Rebirth, function(id)
	uiAction:FireServer("Ausruesten", id)
end, function()
	uiAction:FireServer("Rebirth")
end)
local eggs = EggPanel.build(gui, Katalog.Eier, function(id)
	uiAction:FireServer("Ausbrueten", id)
end)

local windows = {
	Kukurin = kukurin.window,
	TierIndex = index.window,
	Shop = shop,
}

local function toggleWindow(id: string)
	local target = windows[id]
	if not target then
		return
	end
	local wasOpen = target.isOpen()
	for _, w in windows do
		w.close()
	end
	if not wasOpen then
		target.open()
	end
end

local hud = Hud.build(gui, toggleWindow, function()
	if eggs.isOpen() then
		eggs.close()
	else
		eggs.open()
	end
end)

-- Skalierung nach Bildschirmgröße, Handy-Layout bei reiner Touch-Bedienung
local scalers: { UIScale } = { shop.scaler, index.window.scaler, kukurin.window.scaler, eggs.scaler, toast.scaler }
for _, s in hud.scalers do
	table.insert(scalers, s)
end

local function rescale()
	local camera = Workspace.CurrentCamera
	local viewport = if camera then camera.ViewportSize else Theme.DesignSize
	local scale = math.clamp(math.min(viewport.X / Theme.DesignSize.X, viewport.Y / Theme.DesignSize.Y), 0.55, 1.35)
	for _, s in scalers do
		s.Scale = scale
	end
	local touch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	hud.setTouch(touch)
	toast.setTouch(touch)
end

local viewportConnection: RBXScriptConnection? = nil
local function watchCamera()
	if viewportConnection then
		viewportConnection:Disconnect()
	end
	local camera = Workspace.CurrentCamera
	if camera then
		viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
	end
	rescale()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera)
UserInputService.LastInputTypeChanged:Connect(rescale)
watchCamera()

-- Spielerdaten -> Anzeigen
local function decode(json: unknown): { [any]: any }
	if type(json) ~= "string" then
		return {}
	end
	local ok, value = pcall(HttpService.JSONDecode, HttpService, json)
	return if ok and type(value) == "table" then value else {}
end

local DATA_ATTRIBUTES = {
	[A.Money] = true,
	[A.Level] = true,
	[A.Training] = true,
	[A.ToNextLevel] = true,
	[A.Rebirths] = true,
	[A.Model] = true,
	[A.AnimalIndex] = true,
	[A.Eggs] = true,
	[A.Wheelie] = true,
	[A.Income] = true,
}

local function refresh()
	local level = player:GetAttribute(A.Level) or 1
	hud.setLevel(level, player:GetAttribute(A.Training) or 0, player:GetAttribute(A.ToNextLevel))
	hud.setMoney(player:GetAttribute(A.Money) or 0, player:GetAttribute(A.Income))
	hud.setWheelie(player:GetAttribute(A.Wheelie) == true)

	local known = {}
	for _, id in decode(player:GetAttribute(A.AnimalIndex)) do
		known[id] = true
	end
	index.refresh(known)

	kukurin.refresh({
		level = level,
		rebirths = player:GetAttribute(A.Rebirths) or 0,
		model = player:GetAttribute(A.Model) or Katalog.Modelle[1].id,
	})
	eggs.refresh(decode(player:GetAttribute(A.Eggs)))
end

player.AttributeChanged:Connect(function(name)
	if DATA_ATTRIBUTES[name] then
		refresh()
	end
end)
refresh()

hintEvent.OnClientEvent:Connect(function(text)
	if type(text) == "string" then
		toast.show(text)
	end
end)

-- Tempo live aus dem eigenen Kukurin (oder zu Fuß aus dem Charakter)
local elapsed = 0
RunService.RenderStepped:Connect(function(dt)
	elapsed += dt
	if elapsed < 0.1 then
		return
	end
	elapsed = 0
	local folder = Workspace:FindFirstChild(Config.FolderName)
	local scooter = folder and folder:FindFirstChild("Kukurin_" .. player.UserId)
	local part: BasePart? = nil
	if scooter and scooter:IsA("Model") and scooter:GetAttribute(A.Rider) == player.UserId then
		part = scooter.PrimaryPart
	else
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root and root:IsA("BasePart") then
			part = root
		end
	end
	local speed = 0
	if part then
		local v = part.AssemblyLinearVelocity
		speed = Vector3.new(v.X, 0, v.Z).Magnitude
	end
	hud.setSpeed(speed * Katalog.KmhProStud)
end)
