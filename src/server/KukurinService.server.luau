-- Verwaltet die Kukurins auf dem Server: jeder Spieler bekommt beim Spawnen
-- seinen eigenen Scooter neben den Spawnpunkt. Aufsteigen über den Prompt
-- (nur der Besitzer), Absteigen über das RemoteEvent "Absteigen".
-- Während der Fahrt ist der Charakter an das Fahrgestell geschweißt,
-- masselos und kollidiert nicht mit der Welt; der Client des Fahrers
-- besitzt die Physik und steuert Antrieb und Ausrichtung.

local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage:WaitForChild("KukurinShared"):WaitForChild("KukurinConfig"))
local KukurinModel = require(ReplicatedStorage:WaitForChild("KukurinShared"):WaitForChild("KukurinModel"))

local A = Config.Attributes
local MOUNT_DISTANCE = 14
local SLOT_COUNT = 8

PhysicsService:RegisterCollisionGroup(Config.RiderCollisionGroup)
PhysicsService:CollisionGroupSetCollidable(Config.RiderCollisionGroup, "Default", false)
PhysicsService:CollisionGroupSetCollidable(Config.RiderCollisionGroup, Config.RiderCollisionGroup, false)

local function ensureFolder(parent: Instance, name: string): Folder
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("Folder") then
		return existing
	end
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local scooterFolder = ensureFolder(Workspace, Config.FolderName)
local remotes = ensureFolder(ReplicatedStorage, Config.RemoteFolderName)
local dismountEvent = remotes:FindFirstChild("Absteigen")
if not dismountEvent then
	dismountEvent = Instance.new("RemoteEvent")
	dismountEvent.Name = "Absteigen"
	dismountEvent.Parent = remotes
end

type RideState = {
	model: Model,
	weld: Weld,
	massless: { [BasePart]: boolean },
	groups: { [BasePart]: string },
	humanoid: { walkSpeed: number, jumpPower: number, jumpHeight: number, autoRotate: boolean },
}

local scooters: { [Player]: Model } = {}
local slots: { [number]: Player } = {}
local rides: { [Player]: RideState } = {}

local function yawOf(cf: CFrame): number
	local look = cf.LookVector
	return math.atan2(-look.X, -look.Z)
end

local function park(model: Model)
	local chassis = model.PrimaryPart
	if not chassis then
		return
	end
	local drive = chassis:FindFirstChild("Antrieb") :: LinearVelocity
	local align = chassis:FindFirstChild("Ausrichtung") :: AlignOrientation
	drive.PlaneVelocity = Vector2.new(0, 0)
	drive.MaxForce = Config.Drive.ParkForce
	align.CFrame = CFrame.Angles(0, yawOf(chassis.CFrame), 0)
end

local function setPromptEnabled(model: Model, enabled: boolean)
	local chassis = model.PrimaryPart
	local prompt = chassis and chassis:FindFirstChild("Aufsteigen")
	if prompt and prompt:IsA("ProximityPrompt") then
		prompt.Enabled = enabled
	end
end

local function dismount(player: Player)
	local ride = rides[player]
	if not ride then
		return
	end
	rides[player] = nil
	ride.weld:Destroy()

	local model = ride.model
	local chassis = model.PrimaryPart
	local character = player.Character
	if character then
		for part, massless in ride.massless do
			if part.Parent then
				part.Massless = massless
				part.CollisionGroup = ride.groups[part]
			end
		end
		character:SetAttribute(A.Riding, nil)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local root = character:FindFirstChild("HumanoidRootPart")
		if humanoid then
			humanoid.WalkSpeed = ride.humanoid.walkSpeed
			humanoid.JumpPower = ride.humanoid.jumpPower
			humanoid.JumpHeight = ride.humanoid.jumpHeight
			humanoid.AutoRotate = ride.humanoid.autoRotate
			humanoid.EvaluateStateMachine = true
			humanoid.PlatformStand = false
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
		if root and root:IsA("BasePart") and chassis then
			-- links neben dem Scooter aufrecht absetzen
			local upright = CFrame.new(chassis.Position) * CFrame.Angles(0, yawOf(chassis.CFrame), 0)
			root.CFrame = upright * CFrame.new(-3.5, 2.5, 0)
		end
	end

	if model.Parent and chassis then
		model:SetAttribute(A.Rider, 0)
		setPromptEnabled(model, true)
		chassis:SetNetworkOwner(nil)
		park(model)
	end
end

local function mount(player: Player, model: Model)
	if rides[player] or model:GetAttribute(A.Owner) ~= player.UserId or model:GetAttribute(A.Rider) ~= 0 then
		return
	end
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local chassis = model.PrimaryPart
	if not (character and humanoid and root and root:IsA("BasePart") and chassis) or humanoid.Health <= 0 then
		return
	end
	if (root.Position - chassis.Position).Magnitude > MOUNT_DISTANCE then
		return
	end

	-- Fußpunkt auf dem Trittbrett; R6 hat keine HipHeight
	local standOffset = model:GetAttribute(A.StandOffset) :: Vector3
	local rootHeight = if humanoid.RigType == Enum.HumanoidRigType.R15 then humanoid.HipHeight + root.Size.Y / 2 else 3
	local c0 = CFrame.new(standOffset + Vector3.new(0, rootHeight, 0))

	local ride: RideState = {
		model = model,
		weld = nil :: any,
		massless = {},
		groups = {},
		humanoid = {
			walkSpeed = humanoid.WalkSpeed,
			jumpPower = humanoid.JumpPower,
			jumpHeight = humanoid.JumpHeight,
			autoRotate = humanoid.AutoRotate,
		},
	}
	-- Der Charakter darf während der Fahrt keine eigene Kraft aufbringen
	-- (sonst schiebt das Laufen den Scooter kameraabhängig zur Seite).
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.JumpHeight = 0
	humanoid.AutoRotate = false
	humanoid.EvaluateStateMachine = false
	for _, part in character:GetDescendants() do
		if part:IsA("BasePart") then
			ride.massless[part] = part.Massless
			ride.groups[part] = part.CollisionGroup
			part.Massless = true
			part.CollisionGroup = Config.RiderCollisionGroup
		end
	end

	humanoid.PlatformStand = true
	root.CFrame = chassis.CFrame * c0
	local weld = Instance.new("Weld")
	weld.Name = "FahrerWeld"
	weld.Part0 = chassis
	weld.Part1 = root
	weld.C0 = c0
	weld.Parent = chassis
	ride.weld = weld
	rides[player] = ride

	model:SetAttribute(A.Rider, player.UserId)
	character:SetAttribute(A.Riding, true)
	setPromptEnabled(model, false)
	chassis:SetNetworkOwner(player)
end

local function removeScooter(player: Player)
	dismount(player)
	local model = scooters[player]
	scooters[player] = nil
	if model then
		model:Destroy()
	end
	for slot, owner in slots do
		if owner == player then
			slots[slot] = nil
		end
	end
end

local function takeSlot(player: Player): number
	for slot = 0, SLOT_COUNT - 1 do
		if not slots[slot] then
			slots[slot] = player
			return slot
		end
	end
	return 0
end

local function placeScooter(player: Player, cf: CFrame)
	local model = KukurinModel.build(cf, player:GetAttribute(A.Model))
	model.Name = "Kukurin_" .. player.UserId
	model:SetAttribute(A.Owner, player.UserId)
	model:SetAttribute(A.Rider, 0)
	model.Parent = scooterFolder
	scooters[player] = model

	local prompt = (model.PrimaryPart :: BasePart):FindFirstChild("Aufsteigen") :: ProximityPrompt
	prompt.Triggered:Connect(function(who)
		mount(who, model)
	end)
end

local function spawnScooter(player: Player)
	removeScooter(player)

	local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation")
	local base = if spawn then spawn.CFrame else CFrame.new(0, 3.7, 118)
	local ground = base.Position.Y - (if spawn then spawn.Size.Y / 2 else 0.5)
	local slot = takeSlot(player)
	local offset = Vector3.new(9 + (slot % 2) * 4, 0, -math.floor(slot / 2) * 7)
	local cf = CFrame.new(base.Position.X, ground, base.Position.Z) * base.Rotation * CFrame.new(offset)
	placeScooter(player, cf)
end

-- Ausgerüstetes Modell gewechselt (Rebirth-Meilenstein oder Ausrüsten):
-- Scooter an Ort und Stelle durch die neue Variante ersetzen; während der
-- Fahrt erst nach dem Absteigen.
local pendingSwap: { [Player]: boolean } = {}
local function swapModel(player: Player)
	if rides[player] then
		pendingSwap[player] = true
		return
	end
	pendingSwap[player] = nil
	local old = scooters[player]
	local chassis = old and old.PrimaryPart
	if not (old and chassis) then
		return
	end
	if old:GetAttribute("ModellId") == (player:GetAttribute(A.Model) or "starter") then
		return
	end
	local upright = CFrame.new(chassis.Position) * CFrame.Angles(0, yawOf(chassis.CFrame), 0)
	local ground = upright * CFrame.new(-KukurinModel.CHASSIS_CENTER)
	old:Destroy()
	placeScooter(player, ground)
end

local function onPlayerAdded(player: Player)
	player:GetAttributeChangedSignal(A.Model):Connect(function()
		swapModel(player)
	end)
	player.CharacterAdded:Connect(function()
		spawnScooter(player)
	end)
	player.CharacterRemoving:Connect(function()
		removeScooter(player)
	end)
	if player.Character then
		spawnScooter(player)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end
Players.PlayerRemoving:Connect(removeScooter)

dismountEvent.OnServerEvent:Connect(function(player)
	dismount(player)
	if pendingSwap[player] then
		swapModel(player)
	end
end)
Players.PlayerRemoving:Connect(function(player)
	pendingSwap[player] = nil
end)

-- Wächter: Während der Fahrt muss die Physik beim Client des Fahrers bleiben,
-- sonst wirken seine Eingaben nicht und der reibungsfreie Scooter rutscht.
local sinceCheck = 0
RunService.Heartbeat:Connect(function(dt)
	sinceCheck += dt
	if sinceCheck < 0.5 then
		return
	end
	sinceCheck = 0
	for player, ride in rides do
		local chassis = ride.model.PrimaryPart
		if chassis and chassis:IsDescendantOf(Workspace) and chassis:GetNetworkOwner() ~= player then
			chassis:SetNetworkOwner(player)
		end
	end
end)
