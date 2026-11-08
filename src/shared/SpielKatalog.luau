-- Spielinhalte: Stages mit je fünf Eiern und fünf Tieren, Wächter,
-- Kukurin-Modelle, Rebirth und Robux-Shop. Die UI und die Server-Dienste
-- lesen nur aus dieser Tabelle.
--
-- Festgelegt (Spielkonzept): je Stage ein Thema, fünf 3D-Eier, fünf Tierarten
-- und ein Wächter. Schwereres Ei = langsamer heim, schwereres Tier, mehr Geld/s.
-- Spätere Stages haben schnellere Wächter.
-- Alle Namen und Zahlen hier sind dokumentierte STARTWERTE für die offenen
-- Fragen 03, 04, 05, 10, 11, 15 und 19 und können frei geändert werden.

local SpielKatalog = {}

local function rgb(r: number, g: number, b: number): Color3
	return Color3.fromRGB(r, g, b)
end

-- Reihenfolge wie im Eiergang (MapBuilder: Stage 1 = Wald direkt hinter dem Tor).
SpielKatalog.Stages = {
	{
		id = "wald", waechterName = "Waldwächter", name = "Wald", ei = "Wald-Ei",
		schale = rgb(244, 240, 222), punkte = rgb(96, 186, 64), waechter = rgb(78, 122, 54),
		tiere = { { "Maus", "🐭" }, { "Hase", "🐰" }, { "Fuchs", "🦊" }, { "Reh", "🦌" }, { "Bär", "🐻" } },
	},
	{
		id = "wueste", waechterName = "Wüstenwächter", name = "Wüste", ei = "Wüsten-Ei",
		schale = rgb(250, 236, 200), punkte = rgb(214, 150, 60), waechter = rgb(178, 128, 64),
		tiere = { { "Skorpion", "🦂" }, { "Echse", "🦎" }, { "Schlange", "🐍" }, { "Kamel", "🐫" }, { "Löwe", "🦁" } },
	},
	{
		id = "eis", waechterName = "Eiswächter", name = "Eis", ei = "Eis-Ei",
		schale = rgb(240, 248, 255), punkte = rgb(110, 180, 236), waechter = rgb(92, 150, 200),
		tiere = { { "Pinguin", "🐧" }, { "Robbe", "🦭" }, { "Eule", "🦉" }, { "Wolf", "🐺" }, { "Mammut", "🦣" } },
	},
	{
		id = "vulkan", waechterName = "Vulkanwächter", name = "Vulkan", ei = "Vulkan-Ei",
		schale = rgb(70, 62, 64), punkte = rgb(255, 120, 40), waechter = rgb(150, 50, 36),
		tiere = { { "Käfer", "🪲" }, { "Fledermaus", "🦇" }, { "Krabbe", "🦀" }, { "Nashorn", "🦏" }, { "T-Rex", "🦖" } },
	},
	{
		id = "kristall", waechterName = "Kristallwächter", name = "Kristall", ei = "Kristall-Ei",
		schale = rgb(236, 226, 255), punkte = rgb(170, 110, 240), waechter = rgb(118, 80, 190),
		tiere = { { "Schmetterling", "🦋" }, { "Pfau", "🦚" }, { "Flamingo", "🦩" }, { "Einhorn", "🦄" }, { "Drache", "🐉" } },
	},
}

-- Fünf Eiergrößen: Gewicht bremst den Kukurin, größer heißt seltener und wertvoller.
SpielKatalog.Groessen = {
	{ name = "klein", tempo = 0.92, haeufigkeit = 40, geld = 1, groesse = 1.0 },
	{ name = "mittel", tempo = 0.84, haeufigkeit = 28, geld = 1.8, groesse = 1.2 },
	{ name = "groß", tempo = 0.75, haeufigkeit = 18, geld = 3, groesse = 1.4 },
	{ name = "riesig", tempo = 0.67, haeufigkeit = 10, geld = 5, groesse = 1.65 },
	{ name = "gigantisch", tempo = 0.6, haeufigkeit = 4, geld = 8, groesse = 1.9 },
}

SpielKatalog.GeldBasis = 2 -- Geld/s eines kleinen Tiers in Stage 1
SpielKatalog.GeldJeStage = 4 -- jede Stage weiter hinten: ×4

SpielKatalog.Waechter = {
	tempoStart = 22, -- Studs/s (≈ km/h) in Stage 1
	tempoJeStage = 4, -- jede Stage weiter hinten schneller
	fangAbstand = 6, -- so nah muss er kommen
}

SpielKatalog.EierJeStage = 6
SpielKatalog.EiNachschub = 15 -- Sekunden bis ein genommenes Ei neu erscheint

-- Abgeleitete Listen für UI und Dienste: Eier und Tiere je Stage und Größe.
SpielKatalog.Eier = {}
SpielKatalog.Tiere = {}
SpielKatalog.EiNachId = {}
SpielKatalog.TierNachId = {}
for s, stage in SpielKatalog.Stages do
	for g, groesse in SpielKatalog.Groessen do
		local id = stage.id .. g
		local tier = stage.tiere[g]
		local geld = math.floor(SpielKatalog.GeldBasis * SpielKatalog.GeldJeStage ^ (s - 1) * groesse.geld + 0.5)
		local ei = {
			id = id,
			name = ("%s (%s)"):format(stage.ei, groesse.name),
			stage = s,
			groesse = g,
			tempo = groesse.tempo,
			skala = groesse.groesse,
			haeufigkeit = groesse.haeufigkeit,
			schale = stage.schale,
			punkte = stage.punkte,
			tier = id,
		}
		local animal = { id = id, name = tier[1], icon = tier[2], geldProSek = geld, stage = s, groesse = g }
		table.insert(SpielKatalog.Eier, ei)
		table.insert(SpielKatalog.Tiere, animal)
		SpielKatalog.EiNachId[id] = ei
		SpielKatalog.TierNachId[id] = animal
	end
end

SpielKatalog.Modelle = {
	{ id = "starter", name = "Starter", rebirth = 0 },
	{ id = "city", name = "City", rebirth = 2 },
}

-- Valentins Rechenbeispiel: erster Rebirth ab Fahrlevel 10.
SpielKatalog.Rebirth = {
	level = 10,
	zeile1 = "Speed startet neu",
	zeile2 = "Danach schneller leveln",
}

-- productId = nil heißt: Produkt ist im Creator Dashboard noch nicht angelegt.
SpielKatalog.Shop = {
	{ id = "neongriffe", name = "Neon-Griffe", text = "Leuchtende Lenkergriffe", preis = 49, icon = "✨", productId = nil },
	{ id = "sternendeck", name = "Sternendeck", text = "Sterne auf dem Trittbrett", preis = 79, icon = "⭐", productId = nil },
}

-- Anzeige-Umrechnung: 1 Stud/s ≈ 1 km/h (Roblox: 1 Stud ≈ 0,28 m).
SpielKatalog.KmhProStud = 1

-- In Roblox Studio zeigt der Server Beispielwerte, damit die UI gefüllt ist.
SpielKatalog.DemoInStudio = {
	Geld = 1250,
	Rebirths = 0,
	Tierindex = { "wald1", "wald2", "wald3" },
	Eier = { wald1 = 2, wald3 = 1 },
}

return SpielKatalog
