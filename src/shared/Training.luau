-- Fahrtraining: reine Rechenlogik (ohne Roblox-Dienste, offline testbar).
--
-- Gefahrene Strecke erhöht das trainierte Tempo stetig. Jedes Level beginnt
-- bei einem festen Tempo; die Leiste zeigt den Weg zum nächsten Level und
-- rechts darüber "noch x km/h bis Level n+1" (Valentins Wunsch).
-- Spätere Level brauchen mehr Strecke. Überschüssige Strecke zählt weiter.
-- Rebirths machen das Training wirksamer, der Wheelie auf seinem Abschnitt auch.
--
-- Alle Werte sind dokumentierte Startwerte für die offenen Fragen 08, 09, 15.
-- Tempo in km/h; 1 km/h ≈ 1 Stud/s (siehe SpielKatalog.KmhProStud).

local Training = {}

Training.START_SPEED = 32 -- Tempo bei Level 1 (vorher fest 38)
Training.SPEED_PER_LEVEL = 2 -- Tempo-Zuwachs je Level
Training.BASE_DISTANCE = 900 -- Studs von Level 1 auf 2
Training.DISTANCE_GROWTH = 1.3 -- jedes weitere Level braucht 30 % mehr
Training.REBIRTH_BONUS = 0.5 -- je Rebirth +50 % Trainingswirkung
Training.WHEELIE_BONUS = 2 -- Faktor auf dem Wheelie-Abschnitt
Training.MAX_LEVEL = 200 -- Schutz gegen Endlosschleifen

export type State = { level: number, progress: number }

-- Strecke (Studs), die Level -> Level+1 braucht
function Training.distanceForLevel(level: number): number
	return Training.BASE_DISTANCE * Training.DISTANCE_GROWTH ^ (level - 1)
end

-- Trainiertes Tempo bei Level und Fortschritt (0..1)
function Training.speedAt(level: number, progress: number): number
	return Training.START_SPEED + (level - 1 + math.clamp(progress, 0, 1)) * Training.SPEED_PER_LEVEL
end

-- Wie viel Tempo noch bis zum nächsten Level fehlt
function Training.toNextLevel(level: number, progress: number): number
	return Training.SPEED_PER_LEVEL * (1 - math.clamp(progress, 0, 1))
end

-- Wirkung einer gefahrenen Strecke
function Training.multiplier(rebirths: number, wheelie: boolean): number
	local m = 1 + math.max(rebirths, 0) * Training.REBIRTH_BONUS
	if wheelie then
		m *= Training.WHEELIE_BONUS
	end
	return m
end

-- Strecke gutschreiben. Gibt den neuen Stand und die gewonnenen Level zurück.
function Training.add(state: State, distance: number, rebirths: number, wheelie: boolean): (State, number)
	local level, progress = state.level, math.clamp(state.progress, 0, 1)
	local effective = math.max(distance, 0) * Training.multiplier(rebirths, wheelie)
	local gained = 0
	while effective > 0 and level < Training.MAX_LEVEL do
		local total = Training.distanceForLevel(level)
		local missing = total * (1 - progress)
		if effective >= missing - 1e-6 then -- Toleranz gegen Rundungsreste an der Levelgrenze
			effective = math.max(effective - missing, 0)
			level += 1
			progress = 0
			gained += 1
		else
			progress += effective / total
			effective = 0
		end
	end
	return { level = level, progress = progress }, gained
end

return Training
