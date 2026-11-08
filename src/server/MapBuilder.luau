-- MapBuilder: baut die Umgebung von "Ride a Kukurin to Steal an Egg".
--
-- Look:      freigegebene Bilder in docs/design (rote Ziegel, Cremekanten,
--            Petrol-Bögen, dunkler Asphalt mit orangen Linien, Laternen,
--            Blockbüsche, gelbe Geländer, Meer).
-- Grundriss: docs/design/grundriss (großes, rundum ummauertes Feld, Plots als
--            diagonale Reihe, Zonen hinter der Rückwand mit beschriftetem
--            Durchgang).
--
-- Enthält nur Map: keine Gehege-Bauten, Tiere, Eier, Scooter oder UI.

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local MapBuilder = {}

local LAND = 3 -- Oberkante des Inselbodens

local function rgb(r: number, g: number, b: number): Color3
	return Color3.fromRGB(r, g, b)
end

local C = {
	Brick = rgb(178, 76, 60),
	Cream = rgb(238, 226, 198),
	Tile = rgb(228, 214, 186),
	Grass = rgb(108, 196, 72),
	GrassPlot = rgb(96, 184, 64),
	Asphalt = rgb(46, 52, 74),
	Orange = rgb(244, 140, 40),
	White = rgb(242, 242, 242),
	Teal = rgb(38, 146, 150),
	TealDark = rgb(26, 108, 114),
	Navy = rgb(30, 40, 74),
	SignText = rgb(252, 242, 218),
	Glass = rgb(74, 146, 214),
	DoorTeal = rgb(32, 92, 100),
	Iron = rgb(40, 42, 52),
	LampGlow = rgb(255, 214, 140),
	Wood = rgb(236, 180, 58),
	Planter = rgb(150, 92, 56),
	Leaf = rgb(92, 182, 62),
	LeafDark = rgb(70, 150, 50),
	Trunk = rgb(118, 80, 50),
	Sea = rgb(40, 150, 220),
	Quay = rgb(206, 196, 176),
	SandWall = rgb(216, 190, 134),
	RoofBox = rgb(176, 176, 182),
	Stone = rgb(150, 150, 158),
}

local M = Enum.Material

---------------------------------------------------------------------------
-- Grundbausteine
---------------------------------------------------------------------------

local function newFolder(parent: Instance, name: string): Folder
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function part(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or M.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

-- Achsparalleler Block zwischen zwei Ecken.
local function box(parent: Instance, name: string, x0: number, y0: number, z0: number, x1: number, y1: number, z1: number, color: Color3, material: Enum.Material?): Part
	local minX, maxX = math.min(x0, x1), math.max(x0, x1)
	local minY, maxY = math.min(y0, y1), math.max(y0, y1)
	local minZ, maxZ = math.min(z0, z1), math.max(z0, z1)
	return part(
		parent,
		name,
		Vector3.new(maxX - minX, maxY - minY, maxZ - minZ),
		CFrame.new((minX + maxX) / 2, (minY + maxY) / 2, (minZ + maxZ) / 2),
		color,
		material
	)
end

-- Bodenplatte mit Oberkante "top".
local function slab(parent: Instance, name: string, x0: number, x1: number, z0: number, z1: number, top: number, thickness: number, color: Color3, material: Enum.Material?): Part
	return box(parent, name, x0, top - thickness, z0, x1, top, z1, color, material)
end

-- Balken von a nach b (für Schrägen und Pfeile, nicht senkrecht verwenden).
local function beam(parent: Instance, name: string, a: Vector3, b: Vector3, width: number, height: number, color: Color3, material: Enum.Material?): Part
	return part(parent, name, Vector3.new(width, height, (b - a).Magnitude), CFrame.lookAt((a + b) / 2, b), color, material)
end

local function addLight(target: BasePart, range: number)
	local light = Instance.new("PointLight")
	light.Color = C.LampGlow
	light.Range = range
	light.Brightness = 1.2
	light.Shadows = false
	light.Parent = target
end

-- Dunkelblaues Schild mit orangem Rahmen, Text auf beiden Seiten.
local function sign(parent: Instance, text: string, cf: CFrame, width: number, height: number): Part
	part(parent, "SchildRahmen", Vector3.new(width + 1.2, height + 1.2, 0.8), cf, C.Orange)
	local board = part(parent, "Schild", Vector3.new(width, height, 1.2), cf, C.Navy)
	for _, face in { Enum.NormalId.Front, Enum.NormalId.Back } do
		local gui = Instance.new("SurfaceGui")
		gui.Face = face
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 40
		gui.LightInfluence = 0
		gui.Parent = board

		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(0.92, 0.8)
		label.Position = UDim2.fromScale(0.04, 0.1)
		label.Font = Enum.Font.FredokaOne
		label.Text = text
		label.TextColor3 = C.SignText
		label.TextScaled = true
		label.Parent = gui
	end
	return board
end

local function lamp(parent: Instance, x: number, z: number, groundY: number)
	box(parent, "LaterneFuss", x - 1, groundY, z - 1, x + 1, groundY + 1.2, z + 1, C.Iron)
	box(parent, "LaternePfahl", x - 0.4, groundY, z - 0.4, x + 0.4, groundY + 13, z + 0.4, C.Iron, M.Metal)
	local glow = box(parent, "LaterneLicht", x - 0.9, groundY + 13, z - 0.9, x + 0.9, groundY + 15.2, z + 0.9, C.LampGlow, M.Neon)
	box(parent, "LaterneDach", x - 1.4, groundY + 15.2, z - 1.4, x + 1.4, groundY + 16, z + 1.4, C.Iron)
	addLight(glow, 24)
end

local function planter(parent: Instance, x: number, z: number, groundY: number)
	box(parent, "Pflanzkasten", x - 2.2, groundY, z - 2.2, x + 2.2, groundY + 2.2, z + 2.2, C.Planter, M.WoodPlanks)
	box(parent, "Busch", x - 1.9, groundY + 2.2, z - 1.9, x + 1.9, groundY + 5.2, z + 1.9, C.Leaf)
	box(parent, "Busch", x - 1.1, groundY + 5.2, z - 1.1, x + 1.1, groundY + 6.6, z + 1.1, C.LeafDark)
end

local function tree(parent: Instance, x: number, z: number, groundY: number, scale: number)
	local s = scale
	box(parent, "Stamm", x - 0.9 * s, groundY, z - 0.9 * s, x + 0.9 * s, groundY + 6 * s, z + 0.9 * s, C.Trunk, M.Wood)
	box(parent, "Krone", x - 4 * s, groundY + 5 * s, z - 4 * s, x + 4 * s, groundY + 10 * s, z + 4 * s, C.Leaf)
	box(parent, "Krone", x - 2.6 * s, groundY + 10 * s, z - 2.6 * s, x + 2.6 * s, groundY + 13 * s, z + 2.6 * s, C.LeafDark)
end

local function fence(parent: Instance, a: Vector3, b: Vector3, groundY: number)
	local length = (b - a).Magnitude
	local unit = (b - a).Unit
	local posts = math.max(1, math.floor(length / 12))
	for i = 0, posts do
		local p = a + unit * (length * i / posts)
		box(parent, "Zaunpfosten", p.X - 0.6, groundY, p.Z - 0.6, p.X + 0.6, groundY + 4, p.Z + 0.6, C.Wood, M.Wood)
	end
	for _, h in { 1.6, 3.2 } do
		beam(parent, "Zaunlatte", Vector3.new(a.X, groundY + h, a.Z), Vector3.new(b.X, groundY + h, b.Z), 0.5, 0.7, C.Wood, M.Wood)
	end
end

-- Gerade Mauer mit Sockel und Abdeckung (entlang X oder Z).
local function wall(parent: Instance, x0: number, z0: number, x1: number, z1: number, height: number, thickness: number, color: Color3, material: Enum.Material)
	local half = thickness / 2
	local minX, maxX, minZ, maxZ
	if math.abs(x1 - x0) >= math.abs(z1 - z0) then
		minX, maxX = math.min(x0, x1), math.max(x0, x1)
		minZ, maxZ = z0 - half, z0 + half
	else
		minX, maxX = x0 - half, x0 + half
		minZ, maxZ = math.min(z0, z1), math.max(z0, z1)
	end
	box(parent, "Mauer", minX, LAND, minZ, maxX, LAND + height, maxZ, color, material)
	box(parent, "Sockel", minX - 0.4, LAND, minZ - 0.4, maxX + 0.4, LAND + 3, maxZ + 0.4, C.Cream, M.Concrete)
	box(parent, "Abdeckung", minX - 0.7, LAND + height, minZ - 0.7, maxX + 0.7, LAND + height + 1.6, maxZ + 0.7, C.Cream, M.Concrete)
end

local function tower(parent: Instance, cx: number, cz: number, size: number, height: number)
	local h = size / 2
	box(parent, "Turm", cx - h, LAND, cz - h, cx + h, LAND + height, cz + h, C.Brick, M.Brick)
	box(parent, "TurmSockel", cx - h - 0.5, LAND, cz - h - 0.5, cx + h + 0.5, LAND + 4, cz + h + 0.5, C.Cream, M.Concrete)
	box(parent, "TurmBand", cx - h - 0.5, LAND + height - 4, cz - h - 0.5, cx + h + 0.5, LAND + height - 2.5, cz + h + 0.5, C.Cream, M.Concrete)
	box(parent, "TurmKappe", cx - h - 1, LAND + height, cz - h - 1, cx + h + 1, LAND + height + 2, cz + h + 1, C.Teal)
end

local function pergola(parent: Instance, cx: number, cz: number, groundY: number, sizeX: number, sizeZ: number, height: number)
	local hx, hz = sizeX / 2, sizeZ / 2
	for _, sx in { -1, 1 } do
		for _, sz in { -1, 1 } do
			local x, z = cx + sx * (hx - 1.5), cz + sz * (hz - 1.5)
			box(parent, "Stuetze", x - 0.9, groundY, z - 0.9, x + 0.9, groundY + height, z + 0.9, C.Teal, M.Metal)
		end
	end
	box(parent, "Dach", cx - hx - 1, groundY + height, cz - hz - 1, cx + hx + 1, groundY + height + 1.4, cz + hz + 1, C.Teal)
	box(parent, "DachOben", cx - hx + 2, groundY + height + 1.4, cz - hz + 2, cx + hx - 2, groundY + height + 2.6, cz + hz - 2, C.TealDark)
	box(parent, "Lichtleiste", cx - hx + 3, groundY + height - 0.4, cz - 0.6, cx + hx - 3, groundY + height, cz + 0.6, C.LampGlow, M.Neon)
end

-- Leuchtende Bodenplatte für den Weltwechsel. "Ankunft" ist der Ort,
-- an dem ein Spieler landet, der zu DIESER Platte reist.
local function portalPad(parent: Instance, name: string, target: string, center: Vector3, arrival: CFrame): Part
	local pad = part(parent, name, Vector3.new(0.6, 14, 14), CFrame.new(center) * CFrame.Angles(0, 0, math.rad(90)), C.Teal, M.Neon)
	pad.Shape = Enum.PartType.Cylinder
	pad.Transparency = 0.15
	pad.CanCollide = false
	pad:SetAttribute("Weltwechsel", true)
	pad:SetAttribute("Ziel", target)
	pad:SetAttribute("Ankunft", arrival)
	return pad
end

---------------------------------------------------------------------------
-- Stadthaus im Stil der Bilder 03/09: Ziegel, Cremegesims, Fensterreihen,
-- Schaufenster mit gestreifter Markise im Erdgeschoss.
---------------------------------------------------------------------------

type HouseStyle = {
	body: Color3,
	trim: Color3,
	roof: Color3,
	material: Enum.Material,
	awning: boolean,
}

local function building(parent: Instance, x0: number, x1: number, z0: number, z1: number, groundY: number, height: number, faces: { Vector3 }, style: HouseStyle)
	local cx, cz = (x0 + x1) / 2, (z0 + z1) / 2
	local sx, sz = x1 - x0, z1 - z0
	local top = groundY + height

	box(parent, "Haus", x0, groundY, z0, x1, top, z1, style.body, style.material)
	box(parent, "HausSockel", x0 - 0.4, groundY, z0 - 0.4, x1 + 0.4, groundY + 1.6, z1 + 0.4, style.trim, M.Concrete)
	box(parent, "Gesims", x0 - 1, top, z0 - 1, x1 + 1, top + 1.8, z1 + 1, style.trim, M.Concrete)
	-- Brüstung als Ring
	local r = top + 1.8
	box(parent, "Bruestung", x0 - 0.6, r, z0 - 0.6, x1 + 0.6, r + 1.2, z0 + 0.6, style.roof)
	box(parent, "Bruestung", x0 - 0.6, r, z1 - 0.6, x1 + 0.6, r + 1.2, z1 + 0.6, style.roof)
	box(parent, "Bruestung", x0 - 0.6, r, z0 + 0.6, x0 + 0.6, r + 1.2, z1 - 0.6, style.roof)
	box(parent, "Bruestung", x1 - 0.6, r, z0 + 0.6, x1 + 0.6, r + 1.2, z1 - 0.6, style.roof)
	box(parent, "Dachkasten", cx - 8, r, cz - 4, cx - 2, r + 4, cz + 2, C.RoofBox, M.Concrete)
	box(parent, "Dachkasten", cx + 3, r, cz + 1, cx + 8, r + 3, cz + 6, C.RoofBox, M.Concrete)

	for faceIndex, n in faces do
		local alongX = n.X ~= 0
		local halfN = if alongX then sx / 2 else sz / 2
		local width = if alongX then sz else sx
		local t = Vector3.new(-n.Z, 0, n.X)
		local faceCenter = Vector3.new(cx, groundY, cz) + n * halfN

		local function at(offsetT: number, y: number, out: number): CFrame
			local p = faceCenter + t * offsetT + Vector3.new(0, y, 0) + n * out
			return CFrame.lookAt(p, p + n)
		end

		-- Erdgeschoss: zwei Schaufenster und eine Tür
		for _, off in { -11, 11 } do
			part(parent, "SchaufensterRahmen", Vector3.new(12.2, 7.2, 0.4), at(off, 5, 0.2), style.trim)
			part(parent, "Schaufenster", Vector3.new(11, 6, 0.4), at(off, 5, 0.35), C.Glass)
		end
		part(parent, "TuerRahmen", Vector3.new(5.4, 8.6, 0.4), at(0, 4.3, 0.2), style.trim)
		part(parent, "Tuer", Vector3.new(4.4, 8, 0.4), at(0, 4, 0.35), C.DoorTeal)

		-- Geschossband über dem Erdgeschoss
		part(parent, "Geschossband", Vector3.new(width + 0.8, 1, 0.8), at(0, 12.5, 0.4), style.trim)

		-- Gestreifte Markise
		if style.awning and faceIndex == 1 then
			local stripes = math.floor((width - 8) / 4)
			local start = -(stripes * 4) / 2 + 2
			for i = 0, stripes - 1 do
				local color = if i % 2 == 0 then C.Orange else C.White
				part(parent, "Markise", Vector3.new(4, 0.4, 4.5), at(start + i * 4, 10.6, 2.2) * CFrame.Angles(math.rad(-22), 0, 0), color)
			end
		end

		-- Obergeschosse
		local rows = math.floor((height - 14) / 10)
		local cols = math.floor((width - 8) / 8)
		for row = 0, rows - 1 do
			local y = 18 + row * 10
			for col = 0, cols - 1 do
				local off = -((cols - 1) * 8) / 2 + col * 8
				part(parent, "FensterRahmen", Vector3.new(4.8, 5.8, 0.4), at(off, y, 0.2), style.trim)
				part(parent, "Fenster", Vector3.new(3.8, 4.8, 0.4), at(off, y, 0.35), C.Glass)
			end
		end
	end
end

local CITY_STYLES: { HouseStyle } = {
	{ body = C.Brick, trim = C.Cream, roof = C.Teal, material = M.Brick, awning = true },
	{ body = C.Cream, trim = C.Brick, roof = C.Brick, material = M.Concrete, awning = true },
	{ body = rgb(196, 92, 70), trim = C.Cream, roof = C.Cream, material = M.Brick, awning = false },
	{ body = C.Brick, trim = C.Cream, roof = C.Cream, material = M.Brick, awning = true },
}
local CITY_HEIGHTS = { 34, 44, 34, 54 }

---------------------------------------------------------------------------
-- Meer und Inseln
---------------------------------------------------------------------------

local CITY = Vector3.new(-1700, 0, 0) -- Mittelpunkt der Trainingsstadt (eigene Insel)

local function buildSea(root: Instance)
	local sea = newFolder(root, "Meer")
	slab(sea, "Wasser", -1024, 1024, -1324, 724, 0.6, 2, C.Sea)
	slab(sea, "Wasser", -2724, -1024, -1024, 1024, 0.6, 2, C.Sea)
	slab(sea, "HofInsel", -200, 200, -165, 190, LAND, 8, C.Quay, M.Concrete)
	slab(sea, "GangInsel", -95, 95, -940, -165, LAND, 8, C.Quay, M.Concrete)
end

---------------------------------------------------------------------------
-- Gehegehof (Grundriss: Screenshots, Look: Bild 01/02)
---------------------------------------------------------------------------

local HOF_X, HOF_Z = 160, 140 -- Innenmaß (halbe Breite / halbe Tiefe)
local WALL_H, WALL_T = 34, 6
local EIER_HALF = 20 -- halbe Breite der Toröffnung zum Eiergang
local CITY_GATE_Z, CITY_GATE_HALF = 40, 16
local SPAWN_Z = 118
local TILE_TOP = LAND + 0.35

local function buildHof(root: Instance)
	local hof = newFolder(root, "Gehegehof")

	-- Wiese und Plattenwege
	slab(hof, "Wiese", -HOF_X, HOF_X, -HOF_Z, HOF_Z, LAND + 0.1, 0.6, C.Grass, M.Grass)
	slab(hof, "Gehweg", -HOF_X, -14, -HOF_Z, -130, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "Gehweg", 14, HOF_X, -HOF_Z, -130, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "Gehweg", -HOF_X, HOF_X, 130, HOF_Z, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "Gehweg", -HOF_X, -150, -130, 130, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "Gehweg", 150, HOF_X, -130, 130, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "Tordurchgang", -EIER_HALF, -14, -146, -HOF_Z, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "Tordurchgang", 14, EIER_HALF, -146, -HOF_Z, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "Vorplatz", -60, -14, -130, -112, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "Vorplatz", 14, 60, -130, -112, TILE_TOP, 0.6, C.Tile, M.Pavement)

	-- Linke Seite: freier Platz für Stationen und Zugang zur Trainingsstadt
	slab(hof, "StadtPlatz", -150, -110, 10, 70, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "StadtWeg", -110, -14, 32, 48, TILE_TOP, 0.6, C.Tile, M.Pavement)
	slab(hof, "StadtDurchgang", -166, -HOF_X, CITY_GATE_Z - CITY_GATE_HALF, CITY_GATE_Z + CITY_GATE_HALF, TILE_TOP, 0.6, C.Tile, M.Pavement)

	-- Fahrspur vom Spawn bis in den Eiergang
	slab(hof, "Fahrspur", -14, 14, -146, 130, LAND + 0.2, 0.6, C.Asphalt, M.Asphalt)
	for _, s in { -1, 1 } do
		slab(hof, "Randlinie", s * 13.6 - 0.6, s * 13.6 + 0.6, -146, 130, LAND + 0.26, 0.2, C.Orange)
	end
	for _, z in { 74, 60, 46 } do
		for _, s in { -1, 1 } do
			beam(hof, "Pfeil", Vector3.new(s * 4.6, LAND + 0.27, z + 3.4), Vector3.new(0, LAND + 0.27, z - 1.2), 1.7, 0.14, C.Orange)
		end
	end
	for i = -2, 2 do
		box(hof, "Zebra", i * 4.8 - 1.3, LAND + 0.13, -122, i * 4.8 + 1.3, LAND + 0.27, -114, C.White)
	end
	-- Beginn der Safe Zone sichtbar am Tor
	slab(hof, "SafeZoneLinie", -EIER_HALF + 0.2, EIER_HALF - 0.2, -143.6, -142.4, LAND + 0.4, 0.3, C.Teal)

	-- Plots als diagonale Reihe (nur Flächen, noch keine Gehege)
	local plots = newFolder(hof, "Plots")
	for k = 0, 6 do
		local cx, cz = 40 + k * 14, -92 + k * 33
		slab(plots, "PlotRand", cx - 24, cx + 24, cz - 16, cz + 16, TILE_TOP, 0.6, C.Tile, M.Pavement)
		local plot = slab(plots, "Plot_" .. (k + 1), cx - 22, cx + 22, cz - 14, cz + 14, LAND + 0.5, 0.6, C.GrassPlot, M.Grass)
		plot:SetAttribute("PlotNummer", k + 1)
	end

	-- Laternen und Blockbüsche
	local deko = newFolder(hof, "Deko")
	for _, z in { -60, -20, 20, 60, 100 } do
		lamp(deko, -17, z, LAND + 0.1)
		lamp(deko, 17, z, LAND + 0.1)
	end
	planter(deko, -24, 122, LAND + 0.1)
	planter(deko, 24, 122, LAND + 0.1)
	planter(deko, -40, -121, TILE_TOP)
	planter(deko, 40, -121, TILE_TOP)
	planter(deko, -130, 14, TILE_TOP)
	planter(deko, -130, 66, TILE_TOP)

	-- Zugang zur Trainingsstadt: Pergola mit Schild und Portal
	local zugang = newFolder(hof, "Zugang_Trainingsstadt")
	pergola(zugang, -146, CITY_GATE_Z, TILE_TOP, 22, 36, 18)
	sign(zugang, "TRAININGSSTADT", CFrame.lookAt(Vector3.new(-133.4, TILE_TOP + 15.5, CITY_GATE_Z), Vector3.new(-123.4, TILE_TOP + 15.5, CITY_GATE_Z)), 24, 4.5)
	local hofArrival = CFrame.lookAt(Vector3.new(-124, LAND + 4, CITY_GATE_Z), Vector3.new(-114, LAND + 4, CITY_GATE_Z))
	portalPad(zugang, "Portal_Trainingsstadt", "Portal_Hof", Vector3.new(-146, TILE_TOP + 0.3, CITY_GATE_Z), hofArrival)
end

local function buildHofWalls(root: Instance)
	local walls = newFolder(root, "Hofmauern")
	local wx, wz = HOF_X + WALL_T / 2, HOF_Z + WALL_T / 2 -- Mauermitte
	local ex, ez = wx + WALL_T / 2, wz + WALL_T / 2 -- Außenkante

	-- Mauerenden enden innerhalb der Torpfeiler (sonst flackern die Stirnflächen)
	wall(walls, -ex, -wz, -(EIER_HALF + 2), -wz, WALL_H, WALL_T, C.Brick, M.Brick)
	wall(walls, EIER_HALF + 2, -wz, ex, -wz, WALL_H, WALL_T, C.Brick, M.Brick)
	wall(walls, -ex, wz, ex, wz, WALL_H, WALL_T, C.Brick, M.Brick)
	wall(walls, wx, -ez, wx, ez, WALL_H, WALL_T, C.Brick, M.Brick)
	wall(walls, -wx, -ez, -wx, CITY_GATE_Z - CITY_GATE_HALF, WALL_H, WALL_T, C.Brick, M.Brick)
	wall(walls, -wx, CITY_GATE_Z + CITY_GATE_HALF, -wx, ez, WALL_H, WALL_T, C.Brick, M.Brick)

	for _, p in { { -wx, -wz }, { wx, -wz }, { -wx, wz }, { wx, wz } } do
		tower(walls, p[1], p[2], 16, 46)
	end
	for _, p in { { -95, -wz }, { 95, -wz }, { wx, 0 }, { -wx, -60 }, { -80, wz }, { 80, wz } } do
		tower(walls, p[1], p[2], 12, 40)
	end
	for _, s in { -1, 1 } do
		tower(walls, -wx, CITY_GATE_Z + s * (CITY_GATE_HALF + 4), 10, 40)
	end
end

-- Großes EIERGANG-Tor (Bild 01): Ziegelpfeiler, Petrol-Fachwerkbogen, Schild.
local function buildEierTor(root: Instance)
	local tor = newFolder(root, "Tor_Eiergang")
	local z = -(HOF_Z + WALL_T / 2)

	for _, s in { -1, 1 } do
		local cx = s * (EIER_HALF + 7)
		box(tor, "Pfeiler", cx - 7, LAND, z - 7, cx + 7, LAND + 48, z + 7, C.Brick, M.Brick)
		box(tor, "PfeilerSockel", cx - 7.6, LAND, z - 7.6, cx + 7.6, LAND + 7, z + 7.6, C.Cream, M.Concrete)
		box(tor, "Warnstreifen", cx - 7.7, LAND + 2.5, z - 7.7, cx + 7.7, LAND + 4.5, z + 7.7, C.Orange)
		box(tor, "PfeilerBand", cx - 7.6, LAND + 40, z - 7.6, cx + 7.6, LAND + 42, z + 7.6, C.Cream, M.Concrete)
		box(tor, "PfeilerKappe", cx - 8.4, LAND + 48, z - 8.4, cx + 8.4, LAND + 50.5, z + 8.4, C.Cream, M.Concrete)
		box(tor, "Laternenhalter", cx - 0.5, LAND + 25, z + 7, cx + 0.5, LAND + 26, z + 9.5, C.Iron)
		local glow = box(tor, "Laterne", cx - 1.2, LAND + 21, z + 8.2, cx + 1.2, LAND + 25, z + 10.6, C.LampGlow, M.Neon)
		addLight(glow, 30)
	end

	box(tor, "Bogen", -33.5, LAND + 42, z - 3, 33.5, LAND + 46, z + 3, C.Teal, M.Metal)
	box(tor, "BogenOben", -14, LAND + 54, z - 3, 14, LAND + 58, z + 3, C.Teal, M.Metal)
	for _, s in { -1, 1 } do
		beam(tor, "BogenSchraege", Vector3.new(s * 34, LAND + 46, z), Vector3.new(s * 13, LAND + 56, z), 6, 4, C.Teal, M.Metal)
		box(tor, "Strebe", s * 20 - 0.7, LAND + 46, z - 1.5, s * 20 + 0.7, LAND + 51, z + 1.5, C.TealDark, M.Metal)
	end
	sign(tor, "EIERGANG", CFrame.new(0, LAND + 50, z + 3.8), 26, 6.5)

	-- Unsichtbare Grenze: hier endet die Verfolgung durch Wächter.
	local safe = box(tor, "SafeZoneGrenze", -EIER_HALF, LAND, z - 0.5, EIER_HALF, LAND + 40, z + 0.5, C.White)
	safe.Transparency = 1
	safe.CanCollide = false
	safe.CanQuery = false
	safe:SetAttribute("Zweck", "Safe Zone: Uebergang Eiergang -> Gehegehof")
end

---------------------------------------------------------------------------
-- Eiergang: ummauerte Zonen hintereinander (Grundriss: Screenshot "Jungle")
---------------------------------------------------------------------------

type Stage = {
	name: string,
	floor: Color3,
	floorMat: Enum.Material,
	path: Color3,
	pathMat: Enum.Material,
}

local STAGES: { Stage } = {
	{ name = "WALD", floor = rgb(88, 168, 60), floorMat = M.Grass, path = rgb(206, 192, 146), pathMat = M.Ground },
	{ name = "WÜSTE", floor = rgb(234, 208, 146), floorMat = M.Sand, path = rgb(208, 176, 116), pathMat = M.Sandstone },
	{ name = "EIS", floor = rgb(228, 240, 250), floorMat = M.Snow, path = rgb(168, 210, 236), pathMat = M.Ice },
	{ name = "VULKAN", floor = rgb(76, 68, 70), floorMat = M.Basalt, path = rgb(232, 112, 42), pathMat = M.CrackedLava },
	{ name = "KRISTALL", floor = rgb(126, 96, 184), floorMat = M.Slate, path = rgb(198, 172, 238), pathMat = M.SmoothPlastic },
}

local ZONE_HALF_X = 70
local ZONE_DEPTH = 150
local ZONE_WALL_T = 6
local ZONE_WALL_H = 30
local ZONE_OPEN = 18

local function stageGate(parent: Instance, z: number, number: number, name: string)
	for _, s in { -1, 1 } do
		local cx = s * (ZONE_OPEN + 4)
		box(parent, "Pfeiler", cx - 4, LAND, z - 4, cx + 4, LAND + 36, z + 4, C.Cream, M.Concrete)
		box(parent, "PfeilerKappe", cx - 4.6, LAND + 36, z - 4.6, cx + 4.6, LAND + 38, z + 4.6, C.Teal)
	end
	box(parent, "Bogen", -25.5, LAND + 30, z - 2.5, 25.5, LAND + 33.5, z + 2.5, C.Teal, M.Metal)
	sign(parent, "STAGE " .. number .. " · " .. name, CFrame.new(0, LAND + 26.5, z + 3.2), 30, 5.5)
end

local function cactus(parent: Instance, x: number, z: number, groundY: number)
	local green = rgb(64, 150, 72)
	box(parent, "Kaktus", x - 1.5, groundY, z - 1.5, x + 1.5, groundY + 14, z + 1.5, green)
	box(parent, "Kaktus", x + 1.5, groundY + 6, z - 1, x + 4.5, groundY + 7.6, z + 1, green)
	box(parent, "Kaktus", x + 3, groundY + 6, z - 1, x + 4.8, groundY + 11, z + 1, green)
	box(parent, "Kaktus", x - 4.2, groundY + 4, z - 1, x - 1.5, groundY + 5.6, z + 1, green)
	box(parent, "Kaktus", x - 4.4, groundY + 4, z - 1, x - 2.6, groundY + 8.5, z + 1, green)
end

local function decorateStage(parent: Instance, k: number, zStart: number)
	local deko = newFolder(parent, "Deko")
	local g = LAND + 0.1
	local function zAt(f: number): number
		return zStart - f * ZONE_DEPTH
	end

	if k == 1 then
		for _, s in { -1, 1 } do
			for _, f in { 0.15, 0.4, 0.65, 0.9 } do
				tree(deko, s * 58, zAt(f), g, 1.3)
			end
		end
	elseif k == 2 then
		for _, p in { { -50, 0.25 }, { 48, 0.45 }, { -44, 0.7 }, { 52, 0.85 } } do
			cactus(deko, p[1], zAt(p[2]), g)
		end
		for _, p in { { 40, 0.2 }, { -56, 0.55 }, { 30, 0.75 } } do
			box(deko, "Fels", p[1] - 5, g, zAt(p[2]) - 4, p[1] + 5, g + 5, zAt(p[2]) + 4, rgb(196, 160, 104), M.Sandstone)
		end
	elseif k == 3 then
		for _, p in { { -50, 0.2, 9 }, { 46, 0.4, 7 }, { -40, 0.65, 6 }, { 54, 0.85, 10 } } do
			local size = p[3]
			box(deko, "Eisblock", p[1] - size / 2, g, zAt(p[2]) - size / 2, p[1] + size / 2, g + size, zAt(p[2]) + size / 2, rgb(170, 215, 240), M.Glacier)
		end
	elseif k == 4 then
		for _, p in { { -46, 0.3 }, { 44, 0.6 }, { -40, 0.85 } } do
			slab(deko, "Lava", p[1] - 9, p[1] + 9, zAt(p[2]) - 9, zAt(p[2]) + 9, LAND + 0.18, 0.2, rgb(255, 120, 40), M.CrackedLava)
		end
		for _, p in { { 52, 0.2 }, { -54, 0.55 }, { 50, 0.8 } } do
			box(deko, "Basaltsaeule", p[1] - 3, g, zAt(p[2]) - 3, p[1] + 3, g + 18, zAt(p[2]) + 3, rgb(56, 50, 54), M.Basalt)
			box(deko, "Basaltsaeule", p[1] - 2, g + 18, zAt(p[2]) - 2, p[1] + 2, g + 24, zAt(p[2]) + 2, rgb(56, 50, 54), M.Basalt)
		end
	else
		for i, p in { { -48, 0.2 }, { 50, 0.4 }, { -42, 0.65 }, { 46, 0.85 } } do
			local color = if i % 2 == 0 then rgb(120, 220, 255) else rgb(190, 130, 255)
			local cf = CFrame.new(p[1], g + 7, zAt(p[2])) * CFrame.Angles(math.rad(8), math.rad(30 * i), math.rad(-10))
			part(deko, "Kristall", Vector3.new(3.4, 15, 3.4), cf, color, M.Neon)
		end
	end
end

local function buildEiergang(root: Instance)
	local gang = newFolder(root, "Eiergang")
	local zStart = -(HOF_Z + WALL_T)
	-- Grenze der Safe Zone (Mitte der Hofmauer mit dem EIERGANG-Tor) und Hofmaße
	gang:SetAttribute("SafeZ", -(HOF_Z + WALL_T / 2))
	gang:SetAttribute("HofHalbeBreite", HOF_X)
	gang:SetAttribute("HofVorne", HOF_Z)

	for k, stage in STAGES do
		local zone = newFolder(gang, "Stage_" .. k)
		zone:SetAttribute("StageNummer", k)
		zone:SetAttribute("Thema", stage.name)

		local zEnd = zStart - ZONE_DEPTH
		-- Maße für Eier und Wächter (EggService)
		zone:SetAttribute("ZStart", zStart)
		zone:SetAttribute("ZEnde", zEnd)
		zone:SetAttribute("HalbeBreite", ZONE_HALF_X)
		zone:SetAttribute("Boden", LAND + 0.1)
		zone:SetAttribute("Durchgang", ZONE_OPEN)
		slab(zone, "Boden", -ZONE_HALF_X, ZONE_HALF_X, zEnd, zStart, LAND + 0.1, 0.6, stage.floor, stage.floorMat)
		local pathEnd = if k < #STAGES then zEnd - ZONE_WALL_T else zEnd
		slab(zone, "Weg", -10, 10, pathEnd, zStart, LAND + 0.2, 0.6, stage.path, stage.pathMat)

		local sideX = ZONE_HALF_X + ZONE_WALL_T / 2
		for _, s in { -1, 1 } do
			wall(zone, s * sideX, zStart, s * sideX, zEnd - ZONE_WALL_T, ZONE_WALL_H, ZONE_WALL_T, C.SandWall, M.Sandstone)
		end

		local wz = zEnd - ZONE_WALL_T / 2
		local outer = ZONE_HALF_X + ZONE_WALL_T
		if k < #STAGES then
			wall(zone, -outer, wz, -(ZONE_OPEN + 2), wz, ZONE_WALL_H, ZONE_WALL_T, C.SandWall, M.Sandstone)
			wall(zone, ZONE_OPEN + 2, wz, outer, wz, ZONE_WALL_H, ZONE_WALL_T, C.SandWall, M.Sandstone)
			stageGate(zone, wz, k + 1, STAGES[k + 1].name)
		else
			wall(zone, -outer, wz, outer, wz, ZONE_WALL_H, ZONE_WALL_T, C.SandWall, M.Sandstone)
		end

		if k == 1 then
			for _, s in { -1, 1 } do
				box(zone, "Pfosten", -40 + s * 9 - 0.5, LAND, zStart - 14.3, -40 + s * 9 + 0.5, LAND + 9, zStart - 13.7, C.Iron)
			end
			sign(zone, "STAGE 1 · " .. stage.name, CFrame.new(-40, LAND + 9, zStart - 14), 20, 4.5)
		end

		decorateStage(zone, k, zStart)
		zStart = zEnd - ZONE_WALL_T
	end
end

---------------------------------------------------------------------------
-- Trainingsstadt (Grundriss: Bild 09, Look: Bilder 03/09, vereinfacht)
---------------------------------------------------------------------------

local CITY_HALF = 305 -- halbe Breite des Straßennetzes
local BLOCK = 110
local STREET = 34
local PITCH = BLOCK + STREET

local function park(parent: Instance, x0: number, x1: number, z0: number, z1: number, walk: number)
	local mx, mz = (x0 + x1) / 2, (z0 + z1) / 2
	slab(parent, "Rasen", x0 + 6, x1 - 6, z0 + 6, z1 - 6, walk + 0.3, 1, C.Grass, M.Grass)
	slab(parent, "Parkweg", mx - 4, mx + 4, z0 + 6.3, z1 - 6.3, walk + 0.4, 1, C.Tile, M.Pavement)
	slab(parent, "Parkweg", x0 + 6.3, mx - 4, mz - 4, mz + 4, walk + 0.4, 1, C.Tile, M.Pavement)
	slab(parent, "Parkweg", mx + 4, x1 - 6.3, mz - 4, mz + 4, walk + 0.4, 1, C.Tile, M.Pavement)
	slab(parent, "Parkplatz", mx - 14, mx + 14, mz - 14, mz + 14, walk + 0.5, 1, C.Cream, M.Pavement)

	local base = walk + 0.5
	box(parent, "Denkmal", mx - 6, base, mz - 6, mx + 6, base + 2.5, mz + 6, C.Stone, M.Concrete)
	box(parent, "Denkmal", mx - 4, base + 2.5, mz - 4, mx + 4, base + 4.5, mz + 4, C.Stone, M.Concrete)
	box(parent, "Obelisk", mx - 1.6, base + 4.5, mz - 1.6, mx + 1.6, base + 21.5, mz + 1.6, C.Cream, M.Concrete)
	box(parent, "ObeliskSpitze", mx - 0.9, base + 21.5, mz - 0.9, mx + 0.9, base + 24.5, mz + 0.9, C.Orange)

	for _, sx in { -1, 1 } do
		for _, sz in { -1, 1 } do
			tree(parent, mx + sx * 30, mz + sz * 30, walk + 0.3, 1.2)
			tree(parent, mx + sx * 40, mz + sz * 18, walk + 0.3, 1)
			planter(parent, mx + sx * 12, mz + sz * 12, base)
		end
		lamp(parent, mx + 6, mz + sx * 26, walk + 0.3)
	end
end

local function clockFace(parent: Instance, center: Vector3, n: Vector3)
	local disc = part(parent, "Uhr", Vector3.new(0.6, 11, 11), CFrame.lookAt(center, center + n) * CFrame.Angles(0, math.rad(90), 0), C.Cream)
	disc.Shape = Enum.PartType.Cylinder
	local base = CFrame.lookAt(center + n * 0.5, center + n * 1.5)
	part(parent, "Zeiger", Vector3.new(0.8, 4.4, 0.3), base * CFrame.new(0, 2, 0), C.Navy)
	part(parent, "Zeiger", Vector3.new(3.4, 0.8, 0.3), base * CFrame.new(1.5, 0, 0), C.Navy)
end

local function landmark(parent: Instance, x0: number, x1: number, z0: number, z1: number, walk: number)
	slab(parent, "Platzbelag", x0 + 6, x1 - 6, z0 + 6, z1 - 6, walk + 0.2, 1, C.Cream, M.Pavement)
	local g = walk + 0.2
	local tx, tz = x0 + 60, z0 + 40

	box(parent, "TurmSockel", tx - 17, g, tz - 17, tx + 17, g + 14, tz + 17, C.Brick, M.Brick)
	box(parent, "TurmBand", tx - 17.5, g + 12, tz - 17.5, tx + 17.5, g + 14.4, tz + 17.5, C.Cream, M.Concrete)
	box(parent, "TurmSchaft", tx - 13, g + 14, tz - 13, tx + 13, g + 74, tz + 13, C.Cream, M.Concrete)
	for _, sx in { -1, 1 } do
		for _, sz in { -1, 1 } do
			box(parent, "TurmKante", tx + sx * 13 - 2, g + 14, tz + sz * 13 - 2, tx + sx * 13 + 2, g + 74, tz + sz * 13 + 2, C.Brick, M.Brick)
		end
	end
	box(parent, "Uhrgeschoss", tx - 15, g + 74, tz - 15, tx + 15, g + 90, tz + 15, C.Brick, M.Brick)
	box(parent, "UhrBand", tx - 15.6, g + 74, tz - 15.6, tx + 15.6, g + 76, tz + 15.6, C.Cream, M.Concrete)
	box(parent, "UhrBand", tx - 15.6, g + 88, tz - 15.6, tx + 15.6, g + 90.4, tz + 15.6, C.Cream, M.Concrete)
	for _, n in { Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1) } do
		clockFace(parent, Vector3.new(tx, g + 82, tz) + n * 15.3, n)
	end
	box(parent, "TurmDach", tx - 13, g + 90, tz - 13, tx + 13, g + 96, tz + 13, C.Teal)
	box(parent, "TurmDach", tx - 9, g + 96, tz - 9, tx + 9, g + 102, tz + 9, C.Teal)
	box(parent, "TurmDach", tx - 5, g + 102, tz - 5, tx + 5, g + 108, tz + 5, C.TealDark)
	box(parent, "TurmSpitze", tx - 1.5, g + 108, tz - 1.5, tx + 1.5, g + 120, tz + 1.5, C.Orange)

	building(parent, x0 + 6, x0 + 51, z0 + 59, z0 + 104, walk, 34, { Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1) }, CITY_STYLES[1])
	for _, p in { { x0 + 96, z0 + 12 }, { x0 + 96, z0 + 98 }, { x0 + 12, z0 + 12 } } do
		lamp(parent, p[1], p[2], g)
	end
	for _, p in { { x0 + 86, z0 + 30 }, { x0 + 86, z0 + 60 }, { x0 + 70, z0 + 90 } } do
		planter(parent, p[1], p[2], g)
	end
end

local function buildCity(root: Instance)
	local city = newFolder(root, "Trainingsstadt")
	local ox, oz = CITY.X, CITY.Z
	local walk = LAND + 0.6
	local edge = CITY_HALF + 30

	slab(city, "Insel", ox - edge - 10, ox + edge + 10, oz - edge - 10, oz + edge + 10, LAND, 8, C.Quay, M.Concrete)
	slab(city, "Asphalt", ox - CITY_HALF, ox + CITY_HALF, oz - CITY_HALF, oz + CITY_HALF, LAND + 0.1, 0.6, C.Asphalt, M.Asphalt)

	-- Promenade mit gelbem Geländer am Wasser
	slab(city, "Promenade", ox - edge, ox + edge, oz - edge, oz - CITY_HALF, walk, 1, C.Tile, M.Pavement)
	slab(city, "Promenade", ox - edge, ox + edge, oz + CITY_HALF, oz + edge, walk, 1, C.Tile, M.Pavement)
	slab(city, "Promenade", ox - edge, ox - CITY_HALF, oz - CITY_HALF, oz + CITY_HALF, walk, 1, C.Tile, M.Pavement)
	slab(city, "Promenade", ox + CITY_HALF, ox + edge, oz - CITY_HALF, oz + CITY_HALF, walk, 1, C.Tile, M.Pavement)
	local f = edge - 2
	local rail = newFolder(city, "Gelaender")
	fence(rail, Vector3.new(ox - f, 0, oz - f), Vector3.new(ox + f, 0, oz - f), walk)
	fence(rail, Vector3.new(ox - f, 0, oz + f), Vector3.new(ox + f, 0, oz + f), walk)
	fence(rail, Vector3.new(ox - f, 0, oz - f), Vector3.new(ox - f, 0, oz + f), walk)
	fence(rail, Vector3.new(ox + f, 0, oz - f), Vector3.new(ox + f, 0, oz + f), walk)
	for _, v in { -275, -165, -55, 55, 165, 275 } do
		lamp(rail, ox + v, oz - CITY_HALF - 4, walk)
		lamp(rail, ox + v, oz + CITY_HALF + 4, walk)
		lamp(rail, ox - CITY_HALF - 4, oz + v, walk)
		lamp(rail, ox + CITY_HALF + 4, oz + v, walk)
	end

	-- Häuserblöcke (4 x 4) mit orangen Randlinien auf der Straße
	for i = 0, 3 do
		for j = 0, 3 do
			local x0 = ox - CITY_HALF + STREET + i * PITCH
			local z0 = oz - CITY_HALF + STREET + j * PITCH
			local x1, z1 = x0 + BLOCK, z0 + BLOCK
			local blockFolder = newFolder(city, ("Block_%d_%d"):format(i, j))

			slab(blockFolder, "Gehweg", x0, x1, z0, z1, walk, 1, C.Tile, M.Pavement)
			slab(blockFolder, "Randlinie", x0 - 2.2, x1 + 2.2, z0 - 2.2, z0 - 1, LAND + 0.15, 0.2, C.Orange)
			slab(blockFolder, "Randlinie", x0 - 2.2, x1 + 2.2, z1 + 1, z1 + 2.2, LAND + 0.15, 0.2, C.Orange)
			slab(blockFolder, "Randlinie", x0 - 2.2, x0 - 1, z0 - 1, z1 + 1, LAND + 0.15, 0.2, C.Orange)
			slab(blockFolder, "Randlinie", x1 + 1, x1 + 2.2, z0 - 1, z1 + 1, LAND + 0.15, 0.2, C.Orange)

			if i == 1 and j == 1 then
				park(blockFolder, x0, x1, z0, z1, walk)
			elseif i == 3 and j == 2 then
				landmark(blockFolder, x0, x1, z0, z1, walk)
			else
				for a = 0, 1 do
					for b = 0, 1 do
						local hx0 = if a == 0 then x0 + 6 else x0 + 59
						local hz0 = if b == 0 then z0 + 6 else z0 + 59
						local faces = {
							Vector3.new(if a == 0 then -1 else 1, 0, 0),
							Vector3.new(0, 0, if b == 0 then -1 else 1),
						}
						local style = CITY_STYLES[(i * 4 + j + a * 2 + b) % #CITY_STYLES + 1]
						local height = CITY_HEIGHTS[(i + j * 3 + a + b * 2) % #CITY_HEIGHTS + 1]
						building(blockFolder, hx0, hx0 + 45, hz0, hz0 + 45, walk, height, faces, style)
					end
				end
				tree(blockFolder, x0 + 3.5, (z0 + z1) / 2, walk, 0.9)
				tree(blockFolder, x1 - 3.5, (z0 + z1) / 2, walk, 0.9)
				lamp(blockFolder, x0 + 3, z0 + 3, walk)
				lamp(blockFolder, x1 - 3, z1 - 3, walk)
			end
		end
	end

	-- Mittellinien und Zebrastreifen
	local marks = newFolder(city, "Markierungen")
	for s = 0, 4 do
		local c = -CITY_HALF + STREET / 2 + s * PITCH
		for i = 0, 3 do
			local b0 = -CITY_HALF + STREET + i * PITCH
			local m = b0 + 14
			while m + 6 <= b0 + BLOCK - 14 do
				box(marks, "Mittellinie", ox + m, LAND + 0.06, oz + c - 0.4, ox + m + 6, LAND + 0.16, oz + c + 0.4, C.White)
				box(marks, "Mittellinie", ox + c - 0.4, LAND + 0.06, oz + m, ox + c + 0.4, LAND + 0.16, oz + m + 6, C.White)
				m += 14
			end
		end
	end
	for _, cx in { -PITCH, 0, PITCH } do
		for _, cz in { -PITCH, 0, PITCH } do
			for _, d in { -1, 1 } do
				local zc, xc = cz + d * 22, cx + d * 22
				for k = -2, 2 do
					box(marks, "Zebra", ox + cx + k * 5.6 - 1.3, LAND + 0.07, oz + zc - 3.5, ox + cx + k * 5.6 + 1.3, LAND + 0.17, oz + zc + 3.5, C.White)
					box(marks, "Zebra", ox + xc - 3.5, LAND + 0.07, oz + cz + k * 5.6 - 1.3, ox + xc + 3.5, LAND + 0.17, oz + cz + k * 5.6 + 1.3, C.White)
				end
			end
		end
	end

	-- Wegweiser "ZUM HOF" an der Hauptachse Richtung Portal
	local signs = newFolder(city, "Wegweiser")
	for i = 0, 2 do
		local x = ox - CITY_HALF + STREET + i * PITCH + BLOCK - 16
		local z = oz - STREET / 2 - 3
		for _, s in { -1, 1 } do
			box(signs, "Pfosten", x + s * 7 - 0.4, walk, z - 0.3, x + s * 7 + 0.4, walk + 9, z + 0.3, C.Iron)
		end
		sign(signs, "ZUM HOF →", CFrame.new(x, walk + 9.5, z), 16, 4)
	end

	-- "Zum Hof": Pergola mit Portal an der Ostpromenade
	local portal = newFolder(city, "Zugang_Hof")
	local px = ox + CITY_HALF + 15
	pergola(portal, px, oz, walk, 22, 40, 16)
	sign(portal, "ZUM HOF", CFrame.lookAt(Vector3.new(px - 12.6, walk + 13.5, oz), Vector3.new(px - 22.6, walk + 13.5, oz)), 18, 4)
	local cityArrival = CFrame.lookAt(Vector3.new(ox + CITY_HALF - 15, LAND + 4, oz), Vector3.new(ox + CITY_HALF - 25, LAND + 4, oz))
	portalPad(portal, "Portal_Hof", "Portal_Trainingsstadt", Vector3.new(px, walk + 0.3, oz), cityArrival)
end

---------------------------------------------------------------------------
-- Licht, Grundplatte, Spawn
---------------------------------------------------------------------------

local function ensure(parent: Instance, className: string, name: string): Instance
	local existing = parent:FindFirstChildOfClass(className)
	if existing then
		return existing
	end
	local inst = Instance.new(className)
	inst.Name = name
	inst.Parent = parent
	return inst
end

local function setupLighting()
	Lighting.ClockTime = 14
	Lighting.GeographicLatitude = 35
	Lighting.Brightness = 2.6
	Lighting.Ambient = rgb(96, 96, 108)
	Lighting.OutdoorAmbient = rgb(150, 150, 162)
	Lighting.EnvironmentDiffuseScale = 1
	Lighting.EnvironmentSpecularScale = 0.6
	Lighting.GlobalShadows = true
	Lighting.ShadowSoftness = 0.25

	local atmosphere = ensure(Lighting, "Atmosphere", "Atmosphere") :: Atmosphere
	atmosphere.Density = 0.22
	atmosphere.Offset = 0.05
	atmosphere.Color = rgb(206, 228, 246)
	atmosphere.Decay = rgb(130, 170, 210)
	atmosphere.Glare = 0.15
	atmosphere.Haze = 0.6

	local color = ensure(Lighting, "ColorCorrectionEffect", "KukurinFarbe") :: ColorCorrectionEffect
	color.Saturation = 0.18
	color.Contrast = 0.06
	color.Brightness = 0.02

	local bloom = ensure(Lighting, "BloomEffect", "KukurinBloom") :: BloomEffect
	bloom.Intensity = 0.35
	bloom.Size = 24
	bloom.Threshold = 1.4

	local clouds = ensure(Workspace.Terrain, "Clouds", "Clouds") :: Clouds
	clouds.Cover = 0.55
	clouds.Density = 0.7
	clouds.Color = C.White
end

local function hideBaseplate()
	local baseplate = Workspace:FindFirstChild("Baseplate")
	if baseplate and baseplate:IsA("BasePart") then
		baseplate.Transparency = 1
		baseplate.CanCollide = false
		baseplate.CanTouch = false
		baseplate.CanQuery = false
		for _, child in baseplate:GetChildren() do
			if child:IsA("Decal") or child:IsA("Texture") then
				child.Transparency = 1
			end
		end
	end
end

local function placeSpawn()
	local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation")
	if spawn then
		-- Standardausrichtung schaut nach -Z, also direkt zum EIERGANG-Tor.
		spawn.CFrame = CFrame.new(0, LAND + 0.2 + spawn.Size.Y / 2, SPAWN_Z)
	end
end

function MapBuilder.build(): Folder
	local old = Workspace:FindFirstChild("KukurinMap")
	if old then
		old:Destroy()
	end

	local root = Instance.new("Folder")
	root.Name = "KukurinMap"

	buildSea(root)
	buildHof(root)
	buildHofWalls(root)
	buildEierTor(root)
	buildEiergang(root)
	buildCity(root)

	root.Parent = Workspace
	setupLighting()
	hideBaseplate()
	placeSpawn()
	return root
end

return MapBuilder
