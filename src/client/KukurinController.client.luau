-- Fahren mit dem Kukurin (Client des Fahrers, der die Physik besitzt).
--   Gas/Bremse/Rückwärts: W/S, Pfeiltasten, Stick oder Handy-Joystick
--   Lenken:               A/D, Pfeiltasten, Stick oder Handy-Joystick
--   Absteigen:            F, Gamepad B oder Handy-Taste "Absteigen"
-- Außerdem für alle Kukurins: Räder drehen, Haltung der Fahrer am Lenker,
-- Aufsteigen-Prompt nur am eigenen Scooter.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage:WaitForChild("KukurinShared"):WaitForChild("KukurinConfig"))
local A = Config.Attributes
local D = Config.Drive

local remotes = ReplicatedStorage:WaitForChild(Config.RemoteFolderName)
local dismountEvent = remotes:WaitForChild("Absteigen") :: RemoteEvent
local scooterFolder = Workspace:WaitForChild(Config.FolderName)

local player = Players.LocalPlayer
local controls = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()

local DISMOUNT_ACTION = "KukurinAbsteigen"
local RIDER_POSE: { [string]: CFrame } = {
	RightShoulder = CFrame.Angles(math.rad(62), 0, 0),
	LeftShoulder = CFrame.Angles(math.rad(62), 0, 0),
	RightElbow = CFrame.Angles(math.rad(12), 0, 0),
	LeftElbow = CFrame.Angles(math.rad(12), 0, 0),
	RightKnee = CFrame.Angles(math.rad(-8), 0, 0),
	LeftKnee = CFrame.Angles(math.rad(-8), 0, 0),
}

local riding: Model? = nil
local yaw, speed, steer = 0, 0, 0
local wheelAngles: { [Model]: number } = {}

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function moveTowards(current: number, target: number, maxDelta: number): number
	if current < target then
		return math.min(current + maxDelta, target)
	end
	return math.max(current - maxDelta, target)
end

local function yawOf(cf: CFrame): number
	local look = cf.LookVector
	return math.atan2(-look.X, -look.Z)
end

local function onDismountAction(_: string, inputState: Enum.UserInputState): Enum.ContextActionResult
	if inputState == Enum.UserInputState.Begin then
		dismountEvent:FireServer()
	end
	return Enum.ContextActionResult.Sink
end

local function startRiding(model: Model)
	riding = model
	yaw = yawOf((model.PrimaryPart :: BasePart).CFrame)
	speed, steer = 0, 0
	ContextActionService:BindAction(DISMOUNT_ACTION, onDismountAction, true, Enum.KeyCode.F, Enum.KeyCode.ButtonB)
	ContextActionService:SetTitle(DISMOUNT_ACTION, "Absteigen")
end

local function stopRiding()
	riding = nil
	ContextActionService:UnbindAction(DISMOUNT_ACTION)
end

-- Nach einem Portalsprung die neue Blickrichtung übernehmen.
player:GetAttributeChangedSignal(A.TeleportYaw):Connect(function()
	local newYaw = player:GetAttribute(A.TeleportYaw)
	if riding and type(newYaw) == "number" then
		yaw = newYaw
	end
end)

local function drive(model: Model, dt: number)
	local chassis = model.PrimaryPart
	local driveForce = chassis and chassis:FindFirstChild("Antrieb")
	local align = chassis and chassis:FindFirstChild("Ausrichtung")
	if not (chassis and driveForce and align) then
		return
	end

	local move = controls:GetMoveVector()
	local throttle = -move.Z
	local maxSpeed = player:GetAttribute(A.MaxSpeed) or D.BaseMaxSpeed

	-- Tempo
	local target, rate
	if throttle > 0.05 then
		if speed < -0.5 then
			target, rate = 0, D.Brake
		else
			target, rate = maxSpeed * throttle, D.Acceleration
		end
	elseif throttle < -0.05 then
		if speed > 0.5 then
			target, rate = 0, D.Brake
		else
			target, rate = -D.ReverseSpeed * -throttle, D.Acceleration * 0.6
		end
	else
		target, rate = 0, D.Coast
	end
	if target ~= 0 and math.sign(target) == math.sign(speed) and math.abs(speed) > math.abs(target) then
		rate = D.Coast -- weniger Gas: sanft ausrollen
	end
	speed = moveTowards(speed, target, rate * dt)

	-- Gegen Wände nicht unbegrenzt Tempo aufstauen
	local dir = Vector3.new(-math.sin(yaw), 0, -math.cos(yaw))
	local actual = chassis.AssemblyLinearVelocity:Dot(dir)
	if speed > 0 then
		speed = math.min(speed, math.max(actual, 0) + D.BlockedSlack)
	elseif speed < 0 then
		speed = math.max(speed, math.min(actual, 0) - D.BlockedSlack)
	end

	-- Lenken: braucht Fahrt, wird bei hohem Tempo etwas ruhiger
	steer = moveTowards(steer, move.X, 5 * dt)
	local absSpeed = math.abs(speed)
	local speedFactor = math.clamp(absSpeed / 8, 0, 1) * (1 - 0.45 * math.clamp(absSpeed / maxSpeed, 0, 1))
	local direction = if speed >= 0 then 1 else -1
	yaw -= steer * D.TurnRate * speedFactor * direction * dt
	dir = Vector3.new(-math.sin(yaw), 0, -math.cos(yaw))

	-- Neigung nach dem Untergrund (Bordsteine, Rampen)
	rayParams.FilterDescendantsInstances = { model, player.Character :: Instance }
	local lift = Vector3.new(0, 3, 0)
	local down = Vector3.new(0, -8, 0)
	local frontHit = Workspace:Raycast(chassis.Position + dir * 2.4 + lift, down, rayParams)
	local rearHit = Workspace:Raycast(chassis.Position - dir * 2.4 + lift, down, rayParams)
	local pitch = 0
	if frontHit and rearHit then
		pitch = math.atan2(frontHit.Position.Y - rearHit.Position.Y, 4.8)
	end
	local roll = -steer * D.LeanAngle * math.clamp(absSpeed / maxSpeed, 0, 1)

	local orientation = align :: AlignOrientation
	orientation.CFrame = CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, roll)
	local linear = driveForce :: LinearVelocity
	linear.MaxForce = D.DriveForce
	linear.PlaneVelocity = Vector2.new(dir.X * speed, dir.Z * speed)

	local steering = chassis:FindFirstChild("Lenkung")
	if steering and steering:IsA("Motor6D") then
		steering.Transform = CFrame.Angles(0, -steer * D.MaxSteerVisual, 0)
	end
end

RunService.PreSimulation:Connect(function(dt)
	local mine = scooterFolder:FindFirstChild("Kukurin_" .. player.UserId)
	local isRiding = mine ~= nil and mine:IsA("Model") and mine.PrimaryPart ~= nil and mine:GetAttribute(A.Rider) == player.UserId
	if isRiding and riding ~= mine then
		startRiding(mine :: Model)
	elseif not isRiding and riding then
		stopRiding()
	end
	if riding then
		drive(riding, dt)
	end
end)

RunService.RenderStepped:Connect(function(dt)
	for _, model in scooterFolder:GetChildren() do
		if not model:IsA("Model") then
			continue
		end
		local chassis = model.PrimaryPart
		if not chassis then
			continue
		end

		-- Aufsteigen nur am eigenen Kukurin anbieten
		if model:GetAttribute(A.Owner) ~= player.UserId then
			local prompt = chassis:FindFirstChild("Aufsteigen")
			if prompt and prompt:IsA("ProximityPrompt") then
				prompt.Enabled = false
			end
		end

		-- Räder drehen passend zum Tempo
		local forward = chassis.AssemblyLinearVelocity:Dot(chassis.CFrame.LookVector)
		local angle = ((wheelAngles[model] or 0) - forward * dt / Config.WheelVisualRadius) % (2 * math.pi)
		wheelAngles[model] = angle
		local spin = CFrame.Angles(angle, 0, 0)
		for _, name in { "RadVorne", "RadHinten" } do
			local joint = model:FindFirstChild(name, true)
			if joint and joint:IsA("Motor6D") then
				joint.Transform = spin
			end
		end

		-- Fahrer hält den Lenker
		local riderId = model:GetAttribute(A.Rider)
		local rider = if type(riderId) == "number" and riderId ~= 0 then Players:GetPlayerByUserId(riderId) else nil
		local character = rider and rider.Character
		if character then
			for jointName, pose in RIDER_POSE do
				local joint = character:FindFirstChild(jointName, true)
				if joint and joint:IsA("Motor6D") then
					joint.Transform = pose
				end
			end
		end
	end

	for model in wheelAngles do
		if model.Parent ~= scooterFolder then
			wheelAngles[model] = nil
		end
	end
end)
