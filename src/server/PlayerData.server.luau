-- Spielerdaten für die Anzeigen und die Aktionen der Oberfläche.
-- Noch ohne Speicherung: beim Beitritt gelten Startwerte, in Roblox Studio
-- die Beispielwerte aus SpielKatalog.DemoInStudio (damit die UI gefüllt ist).
-- Jede Aktion aus der UI wird hier geprüft. Nicht fertige Funktionen
-- antworten mit einem Hinweis, statt etwas zu vergeben.

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local Katalog = require(shared:WaitForChild("SpielKatalog"))
local PlayerStats = require(script.Parent:WaitForChild("PlayerStats"))
local A = Config.Attributes

local function ensure(parent: Instance, className: string, name: string): Instance
	local existing = parent:FindFirstChild(name)
	if existing then
		return existing
	end
	local inst = Instance.new(className)
	inst.Name = name
	inst.Parent = parent
	return inst
end

local remotes = ensure(ReplicatedStorage, "Folder", Config.RemoteFolderName)
local uiAction = ensure(remotes, "RemoteEvent", "UIAktion") :: RemoteEvent
local hintEvent = ensure(remotes, "RemoteEvent", "Hinweis") :: RemoteEvent

local function find(list: { any }, id: any): any
	for _, entry in list do
		if entry.id == id then
			return entry
		end
	end
	return nil
end

local function hint(player: Player, text: string)
	hintEvent:FireClient(player, text)
end

local function setDefaults(player: Player)
	local demo = if RunService:IsStudio() then Katalog.DemoInStudio else nil
	player:SetAttribute(A.Money, if demo then demo.Geld else 0)
	player:SetAttribute(A.Rebirths, if demo then demo.Rebirths else 0)
	player:SetAttribute(A.Model, Katalog.Modelle[1].id)
	player:SetAttribute(A.Motor, 0)
	-- Fahrtraining startet immer echt bei Level 1 (auch in Studio).
	PlayerStats.setTraining(player, 1, 0)
	-- Modellwechsel ändert das Höchsttempo
	player:GetAttributeChangedSignal(A.Model):Connect(function()
		PlayerStats.refresh(player)
	end)
	player:SetAttribute(A.AnimalIndex, HttpService:JSONEncode(if demo then demo.Tierindex else {}))
	player:SetAttribute(A.Eggs, HttpService:JSONEncode(if demo then demo.Eier else {}))
	player:SetAttribute(A.Wheelie, false)
end

Players.PlayerAdded:Connect(setDefaults)
for _, player in Players:GetPlayers() do
	setDefaults(player)
end

local lastAction: { [Player]: number } = {}
Players.PlayerRemoving:Connect(function(player)
	lastAction[player] = nil
end)

uiAction.OnServerEvent:Connect(function(player: Player, action: unknown, arg: unknown)
	if type(action) ~= "string" then
		return
	end
	local now = os.clock()
	if (lastAction[player] or 0) + 0.3 > now then
		return
	end
	lastAction[player] = now

	if action == "Kaufen" then
		local item = find(Katalog.Shop, arg)
		if not item then
			return
		end
		if item.productId then
			MarketplaceService:PromptProductPurchase(player, item.productId)
		else
			hint(player, item.name .. " ist noch nicht im Shop eingerichtet.")
		end
	elseif action == "Ausruesten" then
		local model = find(Katalog.Modelle, arg)
		if not model then
			return
		end
		if (player:GetAttribute(A.Rebirths) or 0) < model.rebirth then
			hint(player, ("%s gibt es ab Rebirth %d."):format(model.name, model.rebirth))
			return
		end
		player:SetAttribute(A.Model, model.id)
		hint(player, model.name .. " ist ausgerüstet.")
	end
	-- "Rebirth" behandelt RebirthService, "Ausbrueten" GehegeService.
end)
