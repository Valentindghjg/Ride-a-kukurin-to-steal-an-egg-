-- Ei als 3D-Modell: Ellipsoid in der Schalenfarbe seiner Stage mit Tupfen,
-- große Eier leuchten leicht. Benutzt vom Eiergang (EggService) und vom
-- Gehege (GehegeService, Eier beim Ausbrüten).

local EggModel = {}


function EggModel.sphere(name: string, size: Vector3, cf: CFrame, color: Color3, parent: Instance): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Sphere
	mesh.Parent = p
	p.Parent = parent
	return p
end

-- Ei als Ellipsoid mit Punkten. Ursprung = Mitte des Eis.
function EggModel.build(ei: any, withLabel: boolean): Model
	local model = Instance.new("Model")
	model.Name = ei.id
	local w = 2.2 * ei.skala
	local h = w * 1.3
	local shell = EggModel.sphere("Schale", Vector3.new(w, h, w), CFrame.new(), ei.schale, model)
	model.PrimaryPart = shell
	local dots = { { 0, 0.35 }, { 72, -0.1 }, { 144, 0.45 }, { 216, 0.05 }, { 288, -0.35 }, { 30, -0.55 }, { 200, 0.6 } }
	for _, d in dots do
		local theta, lat = math.rad(d[1]), d[2]
		local c = math.cos(math.asin(lat))
		-- Punkt tief in die Schale setzen, damit nur ein flacher Tupfen herausschaut
		local pos = Vector3.new(w / 2 * c * math.cos(theta), h / 2 * lat, w / 2 * c * math.sin(theta)) * 0.86
		EggModel.sphere("Punkt", Vector3.new(w * 0.3, w * 0.3, w * 0.3), CFrame.new(pos), ei.punkte, model)
	end
	if ei.groesse >= 4 then
		local glow = Instance.new("PointLight")
		glow.Color = ei.punkte
		glow.Range = 10
		glow.Brightness = 1.5
		glow.Parent = shell
	end
	if withLabel then
		local gui = Instance.new("BillboardGui")
		gui.Size = UDim2.fromOffset(220, 44)
		gui.StudsOffset = Vector3.new(0, h / 2 + 1.6, 0)
		gui.MaxDistance = 80
		gui.Parent = shell
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.FredokaOne
		label.Text = ei.name
		label.TextScaled = true
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Parent = gui
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 2
		stroke.Color = Color3.fromRGB(16, 20, 42)
		stroke.Parent = label
	end
	return model
end

return EggModel
