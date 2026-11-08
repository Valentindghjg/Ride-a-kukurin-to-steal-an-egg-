-- Gemeinsames Aussehen der Oberfläche (Bilder 02 und 04–07): kräftige Farben,
-- dunkle Umrandung, runde Ecken, weiße Schrift mit dunkler Kontur.
-- Layout ohne UIListLayout/UIGridLayout: Positionen werden hier berechnet,
-- damit sie überall gleich und vorhersehbar sind.

local Theme = {}

local function rgb(r: number, g: number, b: number): Color3
	return Color3.fromRGB(r, g, b)
end

Theme.Font = Enum.Font.FredokaOne
Theme.DesignSize = Vector2.new(1280, 720) -- Bezugsgröße für die Skalierung

Theme.C = {
	Navy = rgb(28, 36, 72),
	NavyLight = rgb(44, 56, 102),
	Outline = rgb(16, 20, 42),
	Orange = rgb(252, 158, 44),
	OrangeDark = rgb(226, 104, 16),
	Cyan = rgb(70, 218, 246),
	CyanDark = rgb(18, 158, 214),
	Purple = rgb(182, 104, 240),
	PurpleDark = rgb(118, 56, 200),
	PurpleCard = rgb(116, 64, 196),
	PurpleCardDark = rgb(76, 38, 150),
	PurpleEdge = rgb(196, 150, 255),
	Green = rgb(126, 226, 70),
	GreenDark = rgb(52, 168, 38),
	Money = rgb(132, 238, 92),
	Red = rgb(240, 62, 62),
	RedDark = rgb(178, 22, 30),
	Cream = rgb(248, 240, 220),
	CreamDark = rgb(224, 212, 186),
	Unknown = rgb(214, 206, 192),
	Silhouette = rgb(70, 70, 76),
	Grey = rgb(236, 238, 244),
	GreyDark = rgb(196, 200, 212),
	Locked = rgb(52, 56, 70),
	White = rgb(255, 255, 255),
	TextDark = rgb(40, 44, 62),
	BarBack = rgb(60, 68, 100),
	Select = rgb(118, 226, 56),
	SelectFill = rgb(226, 248, 200),
}

function Theme.udim(x: number, y: number): UDim2
	return UDim2.fromOffset(x, y)
end

function Theme.frame(parent: Instance, name: string, pos: UDim2, size: UDim2, color: Color3, anchor: Vector2?): Frame
	local f = Instance.new("Frame")
	f.Name = name
	f.AnchorPoint = anchor or Vector2.new(0, 0)
	f.Position = pos
	f.Size = size
	f.BackgroundColor3 = color
	f.BorderSizePixel = 0
	f.Parent = parent
	return f
end

-- Unsichtbarer Behälter
function Theme.group(parent: Instance, name: string, pos: UDim2, size: UDim2, anchor: Vector2?): Frame
	local f = Theme.frame(parent, name, pos, size, Theme.C.White, anchor)
	f.BackgroundTransparency = 1
	return f
end

function Theme.corner(inst: Instance, px: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, px)
	c.Parent = inst
end

function Theme.round(inst: Instance)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0.5, 0)
	c.Parent = inst
end

function Theme.stroke(inst: Instance, color: Color3, thickness: number): UIStroke
	local s = Instance.new("UIStroke")
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Color = color
	s.Thickness = thickness
	s.Parent = inst
	return s
end

-- Roblox multipliziert den Verlauf mit der Hintergrundfarbe, deshalb wird die
-- Fläche hier auf Weiß gesetzt; die Farben kommen allein aus dem Verlauf.
function Theme.gradient(inst: Instance, top: Color3, bottom: Color3): UIGradient
	if inst:IsA("GuiObject") then
		(inst :: GuiObject).BackgroundColor3 = Theme.C.White
	end
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(top, bottom)
	g.Rotation = 90
	g.Parent = inst
	return g
end

export type TextOptions = {
	color: Color3?,
	align: Enum.TextXAlignment?,
	outline: number?, -- Konturstärke, 0 = keine
	outlineColor: Color3?,
	anchor: Vector2?,
}

function Theme.text(parent: Instance, name: string, text: string, pos: UDim2, size: UDim2, options: TextOptions?): TextLabel
	local o = options or {}
	local label = Instance.new("TextLabel")
	label.Name = name
	label.BackgroundTransparency = 1
	label.AnchorPoint = o.anchor or Vector2.new(0, 0)
	label.Position = pos
	label.Size = size
	label.Font = Theme.Font
	label.Text = text
	label.TextColor3 = o.color or Theme.C.White
	label.TextScaled = true
	label.TextXAlignment = o.align or Enum.TextXAlignment.Center
	label.Parent = parent
	local outline = if o.outline ~= nil then o.outline else 2.5
	if outline > 0 then
		local s = Instance.new("UIStroke")
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		s.Color = o.outlineColor or Theme.C.Outline
		s.Thickness = outline
		s.Parent = label
	end
	return label
end

-- Emoji als Symbol (ohne Kontur)
function Theme.icon(parent: Instance, name: string, emoji: string, pos: UDim2, size: UDim2, anchor: Vector2?): TextLabel
	return Theme.text(parent, name, emoji, pos, size, { outline = 0, anchor = anchor })
end

-- Großer Knopf mit Verlauf, dunkler Umrandung und Drückeffekt.
function Theme.button(parent: Instance, name: string, pos: UDim2, size: UDim2, top: Color3, bottom: Color3, anchor: Vector2?): TextButton
	local b = Instance.new("TextButton")
	b.Name = name
	b.AnchorPoint = anchor or Vector2.new(0, 0)
	b.Position = pos
	b.Size = size
	b.Text = ""
	b.AutoButtonColor = false
	b.BackgroundColor3 = Theme.C.White
	b.BorderSizePixel = 0
	b.Parent = parent
	Theme.corner(b, 14)
	Theme.stroke(b, Theme.C.Outline, 3)
	Theme.gradient(b, top, bottom)
	-- Drückeffekt als dunkle Überlagerung; die Farben bleiben frei änderbar.
	local shade = Instance.new("Frame")
	shade.Name = "Druck"
	shade.Size = UDim2.fromScale(1, 1)
	shade.BackgroundColor3 = Color3.new(0, 0, 0)
	shade.BackgroundTransparency = 1
	shade.BorderSizePixel = 0
	shade.ZIndex = 2
	shade.Parent = b
	Theme.corner(shade, 14)
	b.MouseButton1Down:Connect(function()
		shade.BackgroundTransparency = 0.75
	end)
	b.MouseButton1Up:Connect(function()
		shade.BackgroundTransparency = 1
	end)
	b.MouseLeave:Connect(function()
		shade.BackgroundTransparency = 1
	end)
	return b
end

-- Rotes X zum Schließen (groß genug für Finger).
function Theme.closeButton(parent: Instance, pos: UDim2, anchor: Vector2?, label: string?): TextButton
	local b = Theme.button(parent, "Schliessen", pos, Theme.udim(52, 52), Theme.C.Red, Theme.C.RedDark, anchor)
	Theme.corner(b, 10)
	Theme.text(b, "X", label or "X", UDim2.fromScale(0.5, 0.5), UDim2.fromScale(0.62, 0.62), { anchor = Vector2.new(0.5, 0.5) })
	return b
end

-- Gezeichnetes Ei (Schale mit Punkten), passend zur Eierfarbe.
function Theme.egg(parent: Instance, name: string, pos: UDim2, size: UDim2, shell: Color3, dots: Color3, anchor: Vector2?): Frame
	local egg = Theme.frame(parent, name, pos, size, shell, anchor)
	Theme.round(egg)
	Theme.stroke(egg, Theme.C.Outline, 2)
	Theme.gradient(egg, shell, shell:Lerp(Color3.new(0.75, 0.75, 0.7), 0.35))
	for _, d in { { 0.32, 0.3, 0.2 }, { 0.62, 0.22, 0.16 }, { 0.55, 0.55, 0.22 }, { 0.26, 0.66, 0.16 }, { 0.7, 0.75, 0.14 } } do
		local dot = Theme.frame(egg, "Punkt", UDim2.fromScale(d[1], d[2]), UDim2.fromScale(d[3], d[3] * 0.8), dots, Vector2.new(0.5, 0.5))
		Theme.round(dot)
	end
	return egg
end

-- Zahlen deutsch formatiert: 1250 -> "1.250"
function Theme.number(n: number): string
	local s = tostring(math.floor(n + 0.5))
	local negative = s:sub(1, 1) == "-"
	if negative then
		s = s:sub(2)
	end
	local out = s:reverse():gsub("(%d%d%d)", "%1."):reverse()
	if out:sub(1, 1) == "." then
		out = out:sub(2)
	end
	return (if negative then "-" else "") .. out
end

-- Eigene Skalierung je Bereich, damit Ecken-Abstände gleich bleiben.
function Theme.scaler(inst: Instance): UIScale
	local s = Instance.new("UIScale")
	s.Name = "Skalierung"
	s.Parent = inst
	return s
end

return Theme
