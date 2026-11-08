-- Gemeinsame Schreibstelle für Level, Trainingsfortschritt und Höchsttempo.
-- Höchsttempo = trainiertes Tempo (Training.luau) + Bonus des ausgerüsteten
-- Kukurin-Modells + Motor-Upgrade aus der Werkstatt.
-- Benutzt von PlayerData, TrainingService, RebirthService, UpgradeService.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local Katalog = require(shared:WaitForChild("SpielKatalog"))
local Training = require(shared:WaitForChild("Training"))
local A = Config.Attributes

local PlayerStats = {}

function PlayerStats.modelBonus(player: Player): number
	return Katalog.modell(player:GetAttribute(A.Model)).tempoBonus or 0
end

function PlayerStats.motorBonus(player: Player): number
	return (player:GetAttribute(A.Motor) or 0) * Katalog.Motor.tempoJeStufe
end

function PlayerStats.setTraining(player: Player, level: number, progress: number)
	player:SetAttribute(A.Level, level)
	player:SetAttribute(A.Training, progress)
	player:SetAttribute(A.MaxSpeed, Training.speedAt(level, progress) + PlayerStats.modelBonus(player) + PlayerStats.motorBonus(player))
	player:SetAttribute(A.ToNextLevel, Training.toNextLevel(level, progress))
end

-- Nach einem Modellwechsel das Höchsttempo neu berechnen
function PlayerStats.refresh(player: Player)
	PlayerStats.setTraining(player, player:GetAttribute(A.Level) or 1, player:GetAttribute(A.Training) or 0)
end

return PlayerStats
