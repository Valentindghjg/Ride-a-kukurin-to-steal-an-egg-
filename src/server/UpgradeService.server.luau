-- Werkstatt: Motor-Upgrade für den Kukurin mit Spielgeld (Spielkonzept:
-- "Mit Spielgeld kann der Spieler seinen aktuellen Kukurin verbessern").
-- Jede Stufe erhöht das Höchsttempo; das Upgrade gilt für alle Modelle und
-- bleibt beim Rebirth erhalten. Werte in SpielKatalog.Motor.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local Katalog = require(shared:WaitForChild("SpielKatalog"))
local PlayerStats = require(script.Parent:WaitForChild("PlayerStats"))
local A = Config.Attributes

local remotes = ReplicatedStorage:WaitForChild(Config.RemoteFolderName)
local hintEvent = remotes:WaitForChild("Hinweis") :: RemoteEvent

while Workspace:GetAttribute("KukurinMapBereit") ~= true do
	Workspace:GetAttributeChangedSignal("KukurinMapBereit"):Wait()
end
local map = Workspace:WaitForChild("KukurinMap")
local werkstatt = map:WaitForChild("Gehegehof"):WaitForChild("Werkstatt")
local bench = werkstatt:WaitForChild("Werkbank") :: BasePart

local function money(n: number): string
	local s = tostring(math.floor(n + 0.5))
	return "$" .. (s:reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", ""))
end

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Motor verbessern"
prompt.ObjectText = "Werkstatt"
prompt.HoldDuration = 0.4
prompt.MaxActivationDistance = 14
prompt.RequiresLineOfSight = false
prompt.Parent = bench

local lastBuy: { [Player]: number } = {}

prompt.Triggered:Connect(function(player: Player)
	local now = os.clock()
	if (lastBuy[player] or 0) + 0.5 > now then
		return
	end
	lastBuy[player] = now

	local stufe = player:GetAttribute(A.Motor) or 0
	if stufe >= Katalog.Motor.maxStufe then
		hintEvent:FireClient(player, "Dein Motor ist voll ausgebaut.")
		return
	end
	local price = Katalog.motorPreis(stufe)
	local current = player:GetAttribute(A.Money) or 0
	if current < price then
		hintEvent:FireClient(player, ("Motor Stufe %d kostet %s. Dir fehlen noch %s."):format(stufe + 1, money(price), money(price - current)))
		return
	end
	player:SetAttribute(A.Money, current - price)
	player:SetAttribute(A.Motor, stufe + 1)
	PlayerStats.refresh(player)
	local nextText = if stufe + 1 >= Katalog.Motor.maxStufe
		then "Voll ausgebaut!"
		else ("Nächste Stufe: %s"):format(money(Katalog.motorPreis(stufe + 1)))
	hintEvent:FireClient(player, ("Motor Stufe %d! +%s km/h. %s"):format(
		stufe + 1,
		tostring(Katalog.Motor.tempoJeStufe):gsub("%.", ","),
		nextText
	))
end)

Players.PlayerRemoving:Connect(function(player)
	lastBuy[player] = nil
end)
