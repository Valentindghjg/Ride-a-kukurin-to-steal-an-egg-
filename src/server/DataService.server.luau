-- Spielstand speichern und laden (DataStore).
--
-- * Laden beim Beitritt (nach den Startwerten aus PlayerData). Fehlt ein
--   Stand, bleiben die Startwerte.
-- * Speichern beim Verlassen, alle 60 Sekunden und beim Herunterfahren.
-- * Schlägt das Laden fehl, wird für diesen Spieler NICHT gespeichert, damit
--   ein vorhandener Stand nie mit Startwerten überschrieben wird.
-- * Roblox Studio nutzt einen eigenen Speicher (Tests berühren keine echten
--   Spielstände). Dafür muss in Studio unter Game Settings > Security
--   "Enable Studio Access to API Services" aktiv sein.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local SaveData = require(script.Parent:WaitForChild("SaveData"))
local A = Config.Attributes

local remotes = ReplicatedStorage:WaitForChild(Config.RemoteFolderName)
local hintEvent = remotes:WaitForChild("Hinweis") :: RemoteEvent

local STORE_NAME = if RunService:IsStudio() then "KukurinSpielstand_Studio" else "KukurinSpielstand_v1"
local AUTOSAVE = 60
local RETRIES = 3

local storeOk, store = pcall(function()
	return DataStoreService:GetDataStore(STORE_NAME)
end)

local loaded: { [Player]: boolean } = {}

local function keyFor(player: Player): string
	return "spieler_" .. player.UserId
end

local function withRetry(fn: () -> any): (boolean, any)
	local ok, result
	for attempt = 1, RETRIES do
		ok, result = pcall(fn)
		if ok then
			return true, result
		end
		if attempt < RETRIES then
			task.wait(attempt)
		end
	end
	return false, result
end

local function load(player: Player)
	-- Startwerte aus PlayerData abwarten
	while player.Parent and player:GetAttribute(A.Money) == nil do
		task.wait()
	end
	if not storeOk then
		warn("[Kukurin] DataStore nicht verfügbar: " .. tostring(store))
		hintEvent:FireClient(player, "Speichern ist hier nicht aktiv. Dein Fortschritt geht beim Verlassen verloren.")
		return
	end
	local ok, data = withRetry(function()
		return store:GetAsync(keyFor(player))
	end)
	if not player.Parent then
		return
	end
	if not ok then
		warn("[Kukurin] Laden fehlgeschlagen für " .. player.Name .. ": " .. tostring(data))
		if RunService:IsStudio() then
			hintEvent:FireClient(player, "Speichern in Studio aus: Game Settings > Security > \"Enable Studio Access to API Services\" einschalten.")
		else
			hintEvent:FireClient(player, "Dein Spielstand konnte nicht geladen werden. Bis zum nächsten Beitritt wird nicht gespeichert.")
		end
		return
	end
	if data ~= nil then
		SaveData.apply(player, data)
	end
	loaded[player] = true
	player:SetAttribute("DatenGeladen", true)
end

local function save(player: Player): boolean
	if not (loaded[player] and storeOk) then
		return false
	end
	local data = SaveData.collect(player)
	local ok, err = withRetry(function()
		return store:UpdateAsync(keyFor(player), function()
			return data
		end)
	end)
	if not ok then
		warn("[Kukurin] Speichern fehlgeschlagen für " .. player.Name .. ": " .. tostring(err))
	end
	return ok
end

Players.PlayerAdded:Connect(load)
for _, player in Players:GetPlayers() do
	task.spawn(load, player)
end

Players.PlayerRemoving:Connect(function(player)
	save(player)
	loaded[player] = nil
end)

-- Automatisch speichern
task.spawn(function()
	while true do
		task.wait(AUTOSAVE)
		for _, player in Players:GetPlayers() do
			task.spawn(save, player)
		end
	end
end)

-- Beim Herunterfahren alle sichern (höchstens ~25 s Zeit)
game:BindToClose(function()
	local pending = 0
	for _, player in Players:GetPlayers() do
		pending += 1
		task.spawn(function()
			save(player)
			pending -= 1
		end)
	end
	local started = os.clock()
	while pending > 0 and os.clock() - started < 25 do
		task.wait(0.2)
	end
end)
