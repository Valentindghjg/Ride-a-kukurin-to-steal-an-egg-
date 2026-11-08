-- Gemeinsame Werte für den Kukurin (Server und Client).
-- Die Fahrwerte sind dokumentierte Startwerte für die offene Frage 07
-- (Fahrgefühl) und lassen sich hier zentral anpassen. Tempo in Studs/s.

local KukurinConfig = {}

KukurinConfig.FolderName = "Kukurins" -- Ordner im Workspace
KukurinConfig.RemoteFolderName = "KukurinRemotes" -- Ordner in ReplicatedStorage
KukurinConfig.RiderCollisionGroup = "KukurinFahrer"

KukurinConfig.Attributes = {
	Owner = "Besitzer", -- UserId des Besitzers (am Modell)
	Rider = "Fahrer", -- UserId des Fahrers, 0 = geparkt (am Modell)
	StandOffset = "StandOffset", -- Fußpunkt relativ zum Fahrgestell (am Modell)
	Riding = "AufKukurin", -- true am Charakter während der Fahrt
	MaxSpeed = "KukurinTempo", -- trainiertes Höchsttempo (am Spieler, kommt mit dem Training)
	TeleportTime = "LetzterWeltwechsel", -- Serverzeit des letzten Portalsprungs (am Spieler)
	TeleportYaw = "LetzterWeltwechselYaw", -- Blickrichtung nach dem Sprung (am Spieler)

	-- Spielerdaten für die Anzeigen (am Spieler, nur der Server schreibt)
	Money = "Geld",
	Level = "FahrLevel",
	Training = "Training", -- Füllstand der Trainingsleiste 0..1
	ToNextLevel = "TempoBisLevel", -- km/h, die bis zum nächsten Level fehlen (Anzeige rechts über der Leiste)
	Rebirths = "Rebirths",
	Model = "Modell", -- id aus SpielKatalog.Modelle
	AnimalIndex = "Tierindex", -- JSON-Liste entdeckter Tier-ids
	Eggs = "Eier", -- JSON-Objekt { eiId = Anzahl }
	Wheelie = "WheelieAktiv", -- true, solange der Wheelie-Bonus zählt
}

KukurinConfig.Drive = {
	BaseMaxSpeed = 38, -- Höchsttempo ohne Training (Laufen = 16)
	ReverseSpeed = 10,
	Acceleration = 22,
	Brake = 55,
	Coast = 12, -- Ausrollen ohne Gas
	TurnRate = math.rad(130), -- Drehrate bei vollem Lenkeinschlag
	MaxSteerVisual = math.rad(28), -- sichtbarer Lenkereinschlag
	LeanAngle = math.rad(10), -- Schräglage in Kurven
	DriveForce = 60000,
	ParkForce = 4000,
	Responsiveness = 35,
	BlockedSlack = 6, -- wie weit das Solltempo über dem tatsächlichen liegen darf
}

KukurinConfig.WheelRadius = 0.95 -- unsichtbare Kontaktkugeln (Fahrphysik)
KukurinConfig.WheelVisualRadius = 0.82 -- sichtbare Räder (Drehgeschwindigkeit)

return KukurinConfig
