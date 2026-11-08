-- Fahrtraining auf dem Server: misst die tatsächlich gefahrene Strecke jedes
-- Fahrers und schreibt Level, Fortschritt und trainiertes Tempo gut.
--
-- Nicht gezählt werden: Stillstand, Portalsprünge (LetzterWeltwechsel),
-- ein neuer Scooter (Respawn) und unplausible Sprünge. Jede Messung wird auf
-- das trainierte Tempo begrenzt, damit ein manipulierter Client nicht schneller
-- trainiert. Den Wheelie erkennt der Server selbst an der Neigung des Scooters:
-- nur der Abschnitt mit angehobenem Vorderrad zählt doppelt.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local Training = require(shared:WaitForChild("Training"))
local A = Config.Attributes

local remotes = ReplicatedStorage:WaitForChild(Config.RemoteFolderName)
local hintEvent = remotes:WaitForChild("Hinweis") :: RemoteEvent

local SAMPLE = 0.2 -- Sekunden zwischen zwei Messungen
local WHEELIE_SIN = math.sin(math.rad(12)) -- ab dieser Neigung zählt der Wheelie
local STANDSTILL = 0.05 -- Studs je Messung, darunter gilt Stillstand

type Track = { model: Model?, last: Vector3?, teleport: any }
local tracks: { [Player]: Track } = {}

local function scooterOf(player: Player): Model?
	local folder = Workspace:FindFirstChild(Config.FolderName)
	local model = folder and folder:FindFirstChild("Kukurin_" .. player.UserId)
	if model and model:IsA("Model") and model:GetAttribute(A.Rider) == player.UserId then
		return model
	end
	return nil
end

local function setWheelie(player: Player, active: boolean)
	if player:GetAttribute(A.Wheelie) ~= active then
		player:SetAttribute(A.Wheelie, active)
	end
end

local function write(player: Player, level: number, progress: number)
	player:SetAttribute(A.Level, level)
	player:SetAttribute(A.Training, progress)
	player:SetAttribute(A.MaxSpeed, Training.speedAt(level, progress))
	player:SetAttribute(A.ToNextLevel, Training.toNextLevel(level, progress))
end

local function measure(player: Player, step: number)
	local track = tracks[player]
	if not track then
		track = { model = nil, last = nil, teleport = nil }
		tracks[player] = track
	end

	local model = scooterOf(player)
	local chassis = model and model.PrimaryPart
	if not (model and chassis) then
		track.model, track.last = nil, nil
		setWheelie(player, false)
		return
	end

	local position = chassis.Position
	local teleport = player:GetAttribute(A.TeleportTime)
	if track.model ~= model or track.teleport ~= teleport or not track.last then
		-- neuer Scooter, Portalsprung oder erste Messung: nur Ausgangspunkt merken
		track.model, track.teleport, track.last = model, teleport, position
		return
	end

	local last = track.last :: Vector3
	track.last = position
	local delta = Vector3.new(position.X - last.X, 0, position.Z - last.Z).Magnitude
	local trained = player:GetAttribute(A.MaxSpeed) or Training.START_SPEED
	local plausible = (trained * 1.3 + 5) * step
	if delta > plausible * 3 then
		return -- Sprung oder Glitch, zählt nicht
	end
	delta = math.min(delta, plausible)
	if delta < STANDSTILL then
		setWheelie(player, false)
		return
	end

	local wheelie = chassis.CFrame.LookVector.Y > WHEELIE_SIN
	setWheelie(player, wheelie)

	local state, gained = Training.add({
		level = player:GetAttribute(A.Level) or 1,
		progress = player:GetAttribute(A.Training) or 0,
	}, delta, player:GetAttribute(A.Rebirths) or 0, wheelie)
	write(player, state.level, state.progress)
	if gained > 0 then
		hintEvent:FireClient(player, ("Level %d! Dein Kukurin fährt jetzt %d km/h."):format(
			state.level,
			math.floor(Training.speedAt(state.level, 0) + 0.5)
		))
	end
end

local elapsed = 0
RunService.Heartbeat:Connect(function(dt)
	elapsed += dt
	if elapsed < SAMPLE then
		return
	end
	local step = elapsed
	elapsed = 0
	for _, player in Players:GetPlayers() do
		measure(player, step)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	tracks[player] = nil
end)
