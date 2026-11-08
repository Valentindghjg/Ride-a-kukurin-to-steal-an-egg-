-- Baut das Kukurin-Modell nach Valentins Fotovorlage: schlanker schwarzer
-- E-Scooter mit rundem Lenkrohr, Klappgelenk, T-Lenker mit Display, Klingel
-- und rundem Scheinwerfer, langem flachen Trittbrett mit abgerundeten Ecken,
-- gebogenen Schutzblechen, Scheibenbremse hinten und orangen Akzenten aus
-- den Design-Bildern.
--
-- Aufbau für die Physik (unverändert gegenüber der ersten Fahrversion):
--   Fahrgestell  unsichtbarer Wurzelteil mit Antrieb (LinearVelocity) und
--                Ausrichtung (AlignOrientation)
--   Kontakt*     zwei unsichtbare, reibungsfreie Kugeln (Radius WheelRadius)
--   LenkKopf     dreht über Motor6D "Lenkung" um die schräge Lenkachse
--   Räder        drehen über Motor6D "RadVorne"/"RadHinten" (nur Optik)
-- Alle sichtbaren Teile sind masselos und kollidieren nicht.
--
-- Lokale Maße: Ursprung am Boden, vorne = -Z, oben = +Y.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("KukurinShared"):WaitForChild("KukurinConfig"))

local KukurinModel = {}

local R = Config.WheelRadius -- Kontaktkugeln
local RV = Config.WheelVisualRadius -- sichtbare Räder
local FRONT_Z, REAR_Z = -2.6, 2.3
local RAKE_TAN = 0.3 -- Neigung der Lenkachse nach hinten
local RAKE = math.atan(RAKE_TAN)
local CHASSIS_CENTER = Vector3.new(0, R, -0.15)
local DECK_TOP = 0.82
local STAND = Vector3.new(0, DECK_TOP, -0.05)
local X_AXIS = Vector3.new(1, 0, 0)

local function rgb(r: number, g: number, b: number): Color3
	return Color3.fromRGB(r, g, b)
end

local COLORS = {
	Frame = rgb(34, 35, 40),
	FrameDark = rgb(22, 23, 27),
	Tube = rgb(42, 44, 50),
	Grip = rgb(18, 18, 20),
	Tire = rgb(24, 24, 27),
	Rim = rgb(52, 54, 60),
	Spoke = rgb(118, 120, 128),
	Rotor = rgb(190, 190, 196),
	Accent = rgb(244, 140, 40),
	Latch = rgb(210, 45, 45),
	Light = rgb(255, 248, 230),
	Tail = rgb(255, 40, 40),
	Screen = rgb(90, 200, 255),
	Lever = rgb(80, 82, 90),
	Bell = rgb(222, 182, 70),
}

local M = Enum.Material
local CYLINDER = Enum.PartType.Cylinder

---------------------------------------------------------------------------
-- Bausteine
---------------------------------------------------------------------------

local function visual(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?, shape: Enum.PartType?): Part
	local p = Instance.new("Part")
	p.Name = name
	if shape then
		p.Shape = shape
	end
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or M.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Anchored = false
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.CastShadow = true
	p.Massless = true
	p.Parent = parent
	return p
end

local function weld(part0: BasePart, part1: BasePart)
	local w = Instance.new("WeldConstraint")
	w.Part0 = part0
	w.Part1 = part1
	w.Parent = part1
end

local function motor(name: string, part0: BasePart, part1: BasePart, pivot: CFrame): Motor6D
	local m = Instance.new("Motor6D")
	m.Name = name
	m.Part0 = part0
	m.Part1 = part1
	m.C0 = part0.CFrame:Inverse() * pivot
	m.C1 = part1.CFrame:Inverse() * pivot
	m.Parent = part0
	return m
end

-- Lage für einen Stab von a nach b in der YZ-Ebene (Breite bleibt entlang X).
-- Funktioniert auch für senkrechte Stäbe.
local function frameYZ(a: Vector3, b: Vector3): CFrame
	local look = (b - a).Unit
	return CFrame.fromMatrix((a + b) / 2, X_AXIS, Vector3.new(0, -look.Z, look.Y))
end

-- Lage für einen Zylinder, dessen Achse von a nach b in der YZ-Ebene läuft.
local function axisYZ(a: Vector3, b: Vector3): CFrame
	local dir = (b - a).Unit
	return CFrame.fromMatrix((a + b) / 2, dir, X_AXIS)
end

-- Punkt auf der Lenkachse in Höhe y (die Achse geht durch die Vorderachse).
local function onAxis(y: number): Vector3
	return Vector3.new(0, y, FRONT_Z + (y - RV) * RAKE_TAN)
end

---------------------------------------------------------------------------
-- Baugruppen
---------------------------------------------------------------------------

-- Rad: Reifen mit gerundeten Flanken, Felge, fünf Speichen, Nabe.
-- Der Reifen trägt den Motor6D, alles andere ist an ihn geschweißt.
local function wheel(parent: Instance, name: string, z: number, hubMotor: boolean): Part
	local center = CFrame.new(0, RV, z)
	local tire = visual(parent, name, Vector3.new(0.42, RV * 2, RV * 2), center, COLORS.Tire, M.Rubber, CYLINDER)
	local function attach(p: Part)
		weld(tire, p)
	end
	for _, s in { -1, 1 } do
		attach(visual(parent, name .. "Flanke", Vector3.new(0.05, RV * 2 - 0.12, RV * 2 - 0.12), center * CFrame.new(s * 0.232, 0, 0), COLORS.Tire, M.Rubber, CYLINDER))
	end
	-- Felge, Speichen und Nabe stehen über die Flanken hinaus, damit man sie sieht.
	attach(visual(parent, name .. "Felge", Vector3.new(0.54, 1.02, 1.02), center, COLORS.Rim, M.Metal, CYLINDER))
	for i = 0, 4 do
		local spokeCf = center * CFrame.Angles(math.rad(72 * i), 0, 0) * CFrame.new(0, 0, -0.27)
		attach(visual(parent, name .. "Speiche", Vector3.new(0.56, 0.1, 0.44), spokeCf, COLORS.Spoke, M.Metal))
	end
	local hubSize = if hubMotor then 0.5 else 0.32
	attach(visual(parent, name .. "Nabe", Vector3.new(0.58, hubSize, hubSize), center, COLORS.Rim, M.Metal, CYLINDER))
	attach(visual(parent, name .. "Kappe", Vector3.new(0.6, 0.18, 0.18), center, COLORS.Accent, M.SmoothPlastic, CYLINDER))
	return tire
end

-- Gebogenes Schutzblech als Kette dünner Segmente um die Radachse.
-- angle 0 = oben, positiv = nach vorne (side = -1) bzw. nach hinten (side = 1).
local function fenderArc(parent: Instance, name: string, axleZ: number, side: number, fromDeg: number, toDeg: number, segments: number, width: number, attachTo: BasePart): { CFrame }
	local radius = RV + 0.13
	local frames = {}
	local function point(deg: number): Vector3
		local a = math.rad(deg)
		return Vector3.new(0, RV + radius * math.cos(a), axleZ + side * radius * math.sin(a))
	end
	for i = 0, segments - 1 do
		local a = point(fromDeg + (toDeg - fromDeg) * i / segments)
		local b = point(fromDeg + (toDeg - fromDeg) * (i + 1) / segments)
		local cf = frameYZ(a, b)
		local p = visual(parent, name, Vector3.new(width, 0.06, (b - a).Magnitude + 0.04), cf, COLORS.Frame)
		weld(attachTo, p)
		table.insert(frames, cf)
	end
	return frames
end

local function addLabel(part: BasePart, face: Enum.NormalId, text: string)
	local gui = Instance.new("SurfaceGui")
	gui.Face = face
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 100
	gui.LightInfluence = 0.3
	gui.Parent = part
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(0.6, 0.9)
	label.Position = UDim2.fromScale(0.2, 0.05)
	label.Font = Enum.Font.FredokaOne
	label.Text = text
	label.TextColor3 = COLORS.Accent
	label.TextScaled = true
	label.Parent = gui
end

---------------------------------------------------------------------------
-- Modell
---------------------------------------------------------------------------

-- Baut einen Kukurin, dessen Bodenmitte bei "cf" steht und nach cf.LookVector fährt.
function KukurinModel.build(cf: CFrame): Model
	local model = Instance.new("Model")
	model.Name = "Kukurin"

	-- Fahrgestell (Wurzel der Baugruppe, unsichtbar)
	local chassis = Instance.new("Part")
	chassis.Name = "Fahrgestell"
	chassis.Size = Vector3.new(1.3, 0.5, 4.6)
	chassis.CFrame = CFrame.new(CHASSIS_CENTER)
	chassis.Transparency = 1
	chassis.CanCollide = false
	chassis.CanTouch = false
	chassis.CanQuery = false
	chassis.RootPriority = 10
	chassis.Parent = model
	model.PrimaryPart = chassis

	-- Bodenkontakt
	local contact = PhysicalProperties.new(0.7, 0, 0, 100, 100)
	for _, info in { { "KontaktVorne", FRONT_Z }, { "KontaktHinten", REAR_Z } } do
		local ball = Instance.new("Part")
		ball.Name = info[1]
		ball.Shape = Enum.PartType.Ball
		ball.Size = Vector3.new(R * 2, R * 2, R * 2)
		ball.CFrame = CFrame.new(0, R, info[2])
		ball.Transparency = 1
		ball.CanQuery = false
		ball.CustomPhysicalProperties = contact
		ball.Parent = model
		weld(chassis, ball)
	end

	local function body(name: string, size: Vector3, pos: CFrame, color: Color3, material: Enum.Material?, shape: Enum.PartType?): Part
		local p = visual(model, name, size, pos, color, material, shape)
		weld(chassis, p)
		return p
	end

	-- Trittbrett: lang und flach mit abgerundeten Ecken (vor dem Hinterrad,
	-- hinter dem Vorderrad), Griffband, Akkuwanne mit Schrägen, oranger Zierlinie.
	local deckFront, deckRear = FRONT_Z + RV + 0.06, REAR_Z - RV - 0.06
	local deckLen = deckRear - deckFront
	local deckZ = (deckFront + deckRear) / 2
	local deckY, deckH, deckW, corner = DECK_TOP - 0.17, 0.3, 1.1, 0.25
	local deck = body("Trittbrett", Vector3.new(deckW, deckH, deckLen - corner * 2), CFrame.new(0, deckY, deckZ), COLORS.Frame)
	body("Trittbrett", Vector3.new(deckW - corner * 2, deckH, deckLen), CFrame.new(0, deckY, deckZ), COLORS.Frame)
	for _, sx in { -1, 1 } do
		for _, sz in { -1, 1 } do
			local pos = CFrame.new(sx * (deckW / 2 - corner), deckY, deckZ + sz * (deckLen / 2 - corner))
			body("TrittbrettEcke", Vector3.new(deckH, corner * 2, corner * 2), pos * CFrame.Angles(0, 0, math.rad(90)), COLORS.Frame, M.SmoothPlastic, CYLINDER)
		end
	end
	addLabel(deck, Enum.NormalId.Left, "Kukurin")
	addLabel(deck, Enum.NormalId.Right, "Kukurin")
	body("Griffband", Vector3.new(deckW - 0.14, 0.04, deckLen - 0.22), CFrame.new(0, DECK_TOP - 0.01, deckZ), COLORS.Grip, M.Sand)
	for _, sx in { -1, 1 } do
		body("Zierlinie", Vector3.new(0.03, 0.06, deckLen - corner * 2), CFrame.new(sx * (deckW / 2 + 0.005), deckY - 0.09, deckZ), COLORS.Accent)
	end
	local tubLen = deckLen - 0.9
	body("Akku", Vector3.new(0.86, 0.16, tubLen), CFrame.new(0, deckY - deckH / 2 - 0.08, deckZ), COLORS.FrameDark)
	body("AkkuSchraege", Vector3.new(0.86, 0.16, 0.36), CFrame.new(0, deckY - deckH / 2 - 0.08, deckZ - tubLen / 2 - 0.18) * CFrame.Angles(0, 0, math.rad(180)), COLORS.FrameDark, M.SmoothPlastic, Enum.PartType.Wedge)
	body("AkkuSchraege", Vector3.new(0.86, 0.16, 0.36), CFrame.new(0, deckY - deckH / 2 - 0.08, deckZ + tubLen / 2 + 0.18) * CFrame.Angles(math.rad(180), 0, 0), COLORS.FrameDark, M.SmoothPlastic, Enum.PartType.Wedge)

	-- Hals vom Trittbrett schräg hinauf zum Klappgelenk (hinter dem Vorderreifen)
	local hingeY = 2.02
	local hinge = onAxis(hingeY) + Vector3.new(0, 0, 0.1)
	local neckBottom = Vector3.new(0, deckY - 0.05, deckFront + 0.22)
	body("Hals", Vector3.new(0.4, 0.3, (hinge - neckBottom).Magnitude), frameYZ(neckBottom, hinge), COLORS.Frame, M.Metal)
	body("Klappgelenk", Vector3.new(0.52, 0.36, 0.36), CFrame.new(hinge), COLORS.FrameDark, M.Metal, CYLINDER)
	body("Klappriegel", Vector3.new(0.06, 0.12, 0.5), CFrame.new(hinge + Vector3.new(0.31, 0.05, 0.08)) * CFrame.Angles(math.rad(-25), 0, 0), COLORS.Latch)

	-- Hinterbau: Ausfallenden, Bremsscheibe mit Sattel, Schutzblech, Rücklicht, Ständer
	for _, sx in { -1, 1 } do
		local a = Vector3.new(sx * 0.37, deckY - 0.05, deckRear - 0.25)
		local b = Vector3.new(sx * 0.37, RV, REAR_Z)
		body("Ausfallende", Vector3.new(0.08, 0.24, (b - a).Magnitude + 0.1), frameYZ(a, b), COLORS.Frame, M.Metal)
		body("Achskappe", Vector3.new(0.08, 0.24, 0.24), CFrame.new(sx * 0.44, RV, REAR_Z), COLORS.FrameDark, M.Metal, CYLINDER)
	end
	body("Bremssattel", Vector3.new(0.1, 0.2, 0.26), CFrame.new(-0.31, RV + 0.27, REAR_Z - 0.16), COLORS.Latch, M.Metal)
	local rearFender = fenderArc(model, "SchutzblechHinten", REAR_Z, 1, -48, 78, 6, 0.5, chassis)
	local fenderStart = Vector3.new(0, RV + (RV + 0.13) * math.cos(math.rad(-48)), REAR_Z + (RV + 0.13) * math.sin(math.rad(-48)))
	local bracketFrom = Vector3.new(0, DECK_TOP - 0.06, deckRear - 0.05)
	body("SchutzblechHalter", Vector3.new(0.4, 0.08, (fenderStart - bracketFrom).Magnitude + 0.05), frameYZ(bracketFrom, fenderStart), COLORS.Frame, M.Metal)
	local lightFrame = rearFender[4] -- Segment hinten oben
	body("RuecklichtGehaeuse", Vector3.new(0.32, 0.07, 0.2), lightFrame * CFrame.new(0, -0.05, 0), COLORS.FrameDark)
	local tail = body("Ruecklicht", Vector3.new(0.26, 0.05, 0.12), lightFrame * CFrame.new(0, -0.09, 0), COLORS.Tail, M.Neon)
	local tailGlow = Instance.new("PointLight")
	tailGlow.Color = COLORS.Tail
	tailGlow.Range = 5
	tailGlow.Brightness = 1
	tailGlow.Parent = tail
	local standA = Vector3.new(-0.5, deckY - 0.2, deckRear - 0.9)
	local standB = Vector3.new(-0.5, deckY - 0.26, deckRear - 0.2)
	body("Staender", Vector3.new(0.08, 0.08, (standB - standA).Magnitude), frameYZ(standA, standB), COLORS.FrameDark, M.Metal)

	-- Lenkung: alles, was sich mit dem Lenker dreht, hängt am LenkKopf.
	local crownY = 1.92
	local pivot = CFrame.new(onAxis(crownY)) * CFrame.Angles(RAKE, 0, 0)
	local head = visual(model, "LenkKopf", Vector3.new(0.2, 0.2, 0.2), pivot, COLORS.Frame)
	head.Transparency = 1
	motor("Lenkung", chassis, head, pivot)

	local function steer(name: string, size: Vector3, pos: CFrame, color: Color3, material: Enum.Material?, shape: Enum.PartType?): Part
		local p = visual(model, name, size, pos, color, material, shape)
		weld(head, p)
		return p
	end
	local tilt = CFrame.Angles(RAKE, 0, 0)

	-- Gabel und vorderes Schutzblech
	steer("Gabelkrone", Vector3.new(0.82, 0.2, 0.42), pivot, COLORS.Frame, M.Metal)
	for _, sx in { -1, 1 } do
		local top = onAxis(crownY) + Vector3.new(sx * 0.34, 0, 0)
		local axle = Vector3.new(sx * 0.34, RV, FRONT_Z)
		steer("Gabel", Vector3.new(0.09, 0.22, (top - axle).Magnitude), frameYZ(top, axle), COLORS.Frame, M.Metal)
		steer("Achskappe", Vector3.new(0.08, 0.26, 0.26), CFrame.new(sx * 0.4, RV, FRONT_Z), COLORS.FrameDark, M.Metal, CYLINDER)
	end
	fenderArc(model, "SchutzblechVorne", FRONT_Z, -1, -22, 78, 6, 0.54, head)

	-- Rundes Lenkrohr mit Klemmhülse, Scheinwerfer und T-Lenker
	local stemBottom, stemTop = onAxis(hingeY - 0.05), onAxis(4.32)
	steer("Lenkrohr", Vector3.new((stemTop - stemBottom).Magnitude, 0.3, 0.3), axisYZ(stemBottom, stemTop), COLORS.Tube, M.Metal, CYLINDER)
	local sleeveA, sleeveB = onAxis(2.25), onAxis(2.85)
	steer("Klemmhuelse", Vector3.new((sleeveB - sleeveA).Magnitude, 0.38, 0.38), axisYZ(sleeveA, sleeveB), COLORS.FrameDark, M.Metal, CYLINDER)
	local ringA, ringB = onAxis(2.86), onAxis(2.92)
	steer("Zierring", Vector3.new((ringB - ringA).Magnitude, 0.34, 0.34), axisYZ(ringA, ringB), COLORS.Accent, M.SmoothPlastic, CYLINDER)

	-- Scheinwerfer zeigt nach vorne, senkrecht zur Lenkachse
	local forward = Vector3.new(0, RAKE_TAN, -1).Unit
	local lampBase = onAxis(3.9)
	steer("ScheinwerferGehaeuse", Vector3.new(0.22, 0.42, 0.42), CFrame.fromMatrix(lampBase + forward * 0.2, forward, X_AXIS), COLORS.FrameDark, M.Metal, CYLINDER)
	local headlight = steer("Scheinwerfer", Vector3.new(0.06, 0.32, 0.32), CFrame.fromMatrix(lampBase + forward * 0.33, forward, X_AXIS), COLORS.Light, M.Neon, CYLINDER)
	local beam = Instance.new("SpotLight")
	beam.Face = Enum.NormalId.Right
	beam.Color = COLORS.Light
	beam.Range = 32
	beam.Angle = 50
	beam.Brightness = 3
	beam.Parent = headlight

	local clampA, clampB = onAxis(4.22), onAxis(4.5)
	steer("Lenkerklemme", Vector3.new((clampB - clampA).Magnitude, 0.36, 0.36), axisYZ(clampA, clampB), COLORS.FrameDark, M.Metal, CYLINDER)
	local bar = onAxis(4.38)
	steer("Lenker", Vector3.new(2.6, 0.22, 0.22), CFrame.new(bar), COLORS.Tube, M.Metal, CYLINDER)
	for _, sx in { -1, 1 } do
		steer("Griff", Vector3.new(0.72, 0.32, 0.32), CFrame.new(bar + Vector3.new(sx * 0.98, 0, 0)), COLORS.Grip, M.Rubber, CYLINDER)
		steer("Griffring", Vector3.new(0.06, 0.34, 0.34), CFrame.new(bar + Vector3.new(sx * 0.6, 0, 0)), COLORS.Accent, M.SmoothPlastic, CYLINDER)
		steer("Endkappe", Vector3.new(0.06, 0.26, 0.26), CFrame.new(bar + Vector3.new(sx * 1.37, 0, 0)), COLORS.Accent, M.SmoothPlastic, CYLINDER)
		steer("Bremshebel", Vector3.new(0.62, 0.05, 0.08), CFrame.new(bar + Vector3.new(sx * 0.86, -0.1, -0.24)) * CFrame.Angles(0, sx * math.rad(-6), 0), COLORS.Lever, M.Metal)
		steer("Hebelhalter", Vector3.new(0.14, 0.14, 0.26), CFrame.new(bar + Vector3.new(sx * 0.5, -0.02, -0.12)), COLORS.FrameDark, M.Metal)
	end
	steer("Klingel", Vector3.new(0.12, 0.22, 0.22), CFrame.new(bar + Vector3.new(-0.38, 0.17, 0)) * CFrame.Angles(0, 0, math.rad(90)), COLORS.Bell, M.Metal, CYLINDER)
	local display = CFrame.new(onAxis(4.55)) * CFrame.Angles(math.rad(22), 0, 0)
	steer("Display", Vector3.new(0.52, 0.1, 0.38), display, COLORS.FrameDark, M.SmoothPlastic)
	steer("DisplayBild", Vector3.new(0.4, 0.02, 0.26), display * CFrame.new(0, 0.055, 0), COLORS.Screen, M.Neon)

	-- Räder
	local front = wheel(model, "Vorderrad", FRONT_Z, true)
	motor("RadVorne", head, front, CFrame.new(0, RV, FRONT_Z))
	local rear = wheel(model, "Hinterrad", REAR_Z, false)
	local rotor = visual(model, "Bremsscheibe", Vector3.new(0.03, 0.66, 0.66), CFrame.new(-0.31, RV, REAR_Z), COLORS.Rotor, M.Metal, CYLINDER)
	weld(rear, rotor)
	motor("RadHinten", chassis, rear, CFrame.new(0, RV, REAR_Z))

	-- Antrieb und Ausrichtung (Werte setzt im Fahrbetrieb der Client des Fahrers)
	local center = Instance.new("Attachment")
	center.Name = "Zentrum"
	center.Parent = chassis

	local drive = Instance.new("LinearVelocity")
	drive.Name = "Antrieb"
	drive.Attachment0 = center
	drive.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
	drive.PrimaryTangentAxis = Vector3.new(1, 0, 0)
	drive.SecondaryTangentAxis = Vector3.new(0, 0, 1)
	drive.RelativeTo = Enum.ActuatorRelativeTo.World
	drive.PlaneVelocity = Vector2.new(0, 0)
	drive.MaxForce = Config.Drive.ParkForce
	drive.Parent = chassis

	local align = Instance.new("AlignOrientation")
	align.Name = "Ausrichtung"
	align.Mode = Enum.OrientationAlignmentMode.OneAttachment
	align.Attachment0 = center
	align.Responsiveness = Config.Drive.Responsiveness
	align.MaxTorque = math.huge
	align.CFrame = cf.Rotation
	align.Parent = chassis

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "Aufsteigen"
	prompt.ActionText = "Aufsteigen"
	prompt.ObjectText = "Kukurin"
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 10
	prompt.RequiresLineOfSight = false
	prompt.Parent = chassis

	model:SetAttribute(Config.Attributes.StandOffset, STAND - CHASSIS_CENTER)
	model:PivotTo(cf * CFrame.new(CHASSIS_CENTER))
	return model
end

return KukurinModel
