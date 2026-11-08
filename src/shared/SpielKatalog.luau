-- Inhalte, die die Oberfläche anzeigt. Alle Einträge sind BEISPIELE aus den
-- freigegebenen Bildern. Die endgültigen Listen sind offen:
--   Tiere und Eier     Frage 11 (Eier- und Tierkatalog)
--   Kukurin-Modelle    Frage 10 und 15 (Modelle, Rebirth-Tabelle)
--   Robux-Artikel      Frage 19 (Sortiment, Preise, Produkt-IDs)
-- Die UI liest nur aus dieser Tabelle, neue Einträge erscheinen automatisch.

local SpielKatalog = {}

SpielKatalog.Tiere = {
	{ id = "hund", name = "Hund", icon = "🐶", geldProSek = 4 },
	{ id = "katze", name = "Katze", icon = "🐱", geldProSek = 8 },
	{ id = "vogel", name = "Vogel", icon = "🐦", geldProSek = 6 },
	{ id = "kuh", name = "Kuh", icon = "🐮", geldProSek = 12 },
	{ id = "schwein", name = "Schwein", icon = "🐷", geldProSek = 10 },
	{ id = "huhn", name = "Huhn", icon = "🐔", geldProSek = 5 },
}

SpielKatalog.Eier = {
	{ id = "wald", name = "Wald-Ei", schale = Color3.fromRGB(248, 246, 232), punkte = Color3.fromRGB(110, 200, 70) },
	{ id = "stadt", name = "Stadt-Ei", schale = Color3.fromRGB(248, 246, 240), punkte = Color3.fromRGB(150, 90, 220) },
}

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
	FahrLevel = 6,
	Training = 0.55,
	TempoBisLevel = 6,
	Rebirths = 0,
	Tierindex = { "hund", "katze", "vogel" },
	Eier = { wald = 3, stadt = 3 },
}

return SpielKatalog
