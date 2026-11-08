-- Rebirth (Spielkonzept): ab dem nötigen Fahrlevel setzt der Spieler Speed,
-- Fahrlevel und Trainingsleiste auf die Startwerte zurück. Tiere, Geld, Eier
-- und Gehegeplätze bleiben (Startwert für Frage 16).
-- Belohnung je Rebirth: Training wirkt stärker (Training.REBIRTH_BONUS) und
-- Tiere verdienen mehr (SpielKatalog.EinkommenJeRebirth). Erreicht der Spieler
-- den Meilenstein eines Kukurin-Modells, bekommt er es genau einmal kostenlos
-- und ausgerüstet (der Meilenstein wird nur beim Erreichen ausgelöst).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local Katalog = require(shared:WaitForChild("SpielKatalog"))
local Training = require(shared:WaitForChild("Training"))
local PlayerStats = require(script.Parent:WaitForChild("PlayerStats"))
local A = Config.Attributes

local remotes = ReplicatedStorage:WaitForChild(Config.RemoteFolderName)
local uiAction = remotes:WaitForChild("UIAktion") :: RemoteEvent
local hintEvent = remotes:WaitForChild("Hinweis") :: RemoteEvent

local lastRequest: { [Player]: number } = {}

local function rebirth(player: Player)
	local rebirths = player:GetAttribute(A.Rebirths) or 0
	local level = player:GetAttribute(A.Level) or 1
	local needed = Katalog.rebirthLevel(rebirths)
	if level < needed then
		hintEvent:FireClient(player, ("Rebirth %d gibt es ab Level %d. Du bist Level %d."):format(rebirths + 1, needed, level))
		return
	end

	rebirths += 1
	player:SetAttribute(A.Rebirths, rebirths)

	-- Meilenstein: Modell genau einmal vergeben und ausrüsten
	local reward = nil
	for _, model in Katalog.Modelle do
		if model.rebirth == rebirths then
			reward = model
		end
	end
	if reward then
		player:SetAttribute(A.Model, reward.id)
	end

	-- Speed, Level und Leiste zurück auf Start (Höchsttempo inkl. Modellbonus)
	PlayerStats.setTraining(player, 1, 0)

	local trainingPercent = math.floor(Training.multiplier(rebirths, false) * 100 + 0.5)
	local incomePercent = math.floor(rebirths * Katalog.EinkommenJeRebirth * 100 + 0.5)
	local text = ("Rebirth %d! Training jetzt %d %%, Tiereinkommen +%d %%."):format(rebirths, trainingPercent, incomePercent)
	if reward then
		text ..= (" Neuer Kukurin: %s!"):format(reward.name)
	end
	hintEvent:FireClient(player, text)
end

uiAction.OnServerEvent:Connect(function(player: Player, action: unknown)
	if action ~= "Rebirth" then
		return
	end
	local now = os.clock()
	if (lastRequest[player] or 0) + 1 > now then
		return
	end
	lastRequest[player] = now
	rebirth(player)
end)

Players.PlayerRemoving:Connect(function(player)
	lastRequest[player] = nil
end)
