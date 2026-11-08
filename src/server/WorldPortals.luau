-- Weltwechsel zwischen Gehegehof und Trainingsstadt über die leuchtenden Platten.
-- Jede Platte hat die Attribute "Ziel" (Name der Gegenplatte) und "Ankunft"
-- (CFrame, an dem man landet, wenn man ZU dieser Platte reist).
-- Der Zeitpunkt des Wechsels steht am Spieler als "LetzterWeltwechsel", damit
-- die spätere Streckenmessung den Sprung nicht als Fahrt zählt.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local WorldPortals = {}

local COOLDOWN = 3
local cooldownUntil: { [Player]: number } = {}

local function findPad(root: Instance, name: string): BasePart?
	local pad = root:FindFirstChild(name, true)
	if pad and pad:IsA("BasePart") then
		return pad
	end
	return nil
end

local function onTouched(root: Instance, pad: BasePart, hit: BasePart)
	local character = hit:FindFirstAncestorOfClass("Model")
	if not character then
		return
	end
	local player = Players:GetPlayerFromCharacter(character)
	if not player then
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
	player:SetAttribute("LetzterWeltwechsel", Workspace:GetServerTimeNow())
	character:PivotTo(arrival)
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
