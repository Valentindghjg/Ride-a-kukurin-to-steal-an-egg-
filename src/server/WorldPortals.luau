-- Weltwechsel zwischen Gehegehof und Trainingsstadt über die leuchtenden Platten.
-- Jede Platte hat die Attribute "Ziel" (Name der Gegenplatte) und "Ankunft"
-- (CFrame, an dem man landet, wenn man ZU dieser Platte reist).
-- Zu Fuß wird der Charakter versetzt, auf dem Kukurin der ganze Scooter samt
-- Fahrer. Zeitpunkt und neue Blickrichtung stehen danach am Spieler, damit die
-- spätere Streckenmessung den Sprung nicht als Fahrt zählt und der Client
-- seine Lenkrichtung übernimmt.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage:WaitForChild("KukurinShared"):WaitForChild("KukurinConfig"))
local A = Config.Attributes

local WorldPortals = {}

local COOLDOWN = 3
local SCOOTER_DROP = CFrame.new(0, -2.5, 0) -- Ankunft gilt für Fußgänger; Scooter etwas tiefer
local cooldownUntil: { [Player]: number } = {}

local function findPad(root: Instance, name: string): BasePart?
	local pad = root:FindFirstChild(name, true)
	if pad and pad:IsA("BasePart") then
		return pad
	end
	return nil
end

local function scooterOf(player: Player): Model?
	local folder = Workspace:FindFirstChild(Config.FolderName)
	local model = folder and folder:FindFirstChild("Kukurin_" .. player.UserId)
	if model and model:IsA("Model") and model:GetAttribute(A.Rider) == player.UserId then
		return model
	end
	return nil
end

-- Wer hat die Platte berührt, und was muss bewegt werden?
local function resolve(hit: BasePart): (Player?, Model?, boolean)
	local model = hit:FindFirstAncestorOfClass("Model")
	if not model then
		return nil, nil, false
	end
	local riderId = model:GetAttribute(A.Rider)
	if model:GetAttribute(A.Owner) ~= nil then
		-- ein Kukurin; geparkte Scooter bleiben stehen
		local rider = if type(riderId) == "number" and riderId ~= 0 then Players:GetPlayerByUserId(riderId) else nil
		return rider, if rider then model else nil, true
	end
	local player = Players:GetPlayerFromCharacter(model)
	if not player then
		return nil, nil, false
	end
	local scooter = scooterOf(player)
	if scooter then
		return player, scooter, true
	end
	return player, model, false
end

local function onTouched(root: Instance, pad: BasePart, hit: BasePart)
	local player, mover, isScooter = resolve(hit)
	if not (player and mover) then
		return
	end

	local now = os.clock()
	if (cooldownUntil[player] or 0) > now then
		return
	end

	local target = findPad(root, pad:GetAttribute("Ziel"))
	local arrival = target and target:GetAttribute("Ankunft")
	if typeof(arrival) ~= "CFrame" then
		warn("[Kukurin] Portal ohne gültiges Ziel: " .. pad.Name)
		return
	end

	cooldownUntil[player] = now + COOLDOWN
	local look = arrival.LookVector
	player:SetAttribute(A.TeleportYaw, math.atan2(-look.X, -look.Z))
	player:SetAttribute(A.TeleportTime, Workspace:GetServerTimeNow())
	mover:PivotTo(if isScooter then arrival * SCOOTER_DROP else arrival)
end

function WorldPortals.setup(root: Instance)
	for _, pad in root:GetDescendants() do
		if pad:IsA("BasePart") and pad:GetAttribute("Weltwechsel") then
			pad.Touched:Connect(function(hit)
				onTouched(root, pad, hit)
			end)
		end
	end
end

Players.PlayerRemoving:Connect(function(player)
	cooldownUntil[player] = nil
end)

return WorldPortals
