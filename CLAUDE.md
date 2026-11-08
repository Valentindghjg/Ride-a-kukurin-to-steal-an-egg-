# Umsetzung in Roblox Studio

**Valentins Stilvorgabe:** Die neun Bilder sind freigegeben. Übernimm daraus die Wege zwischen den Gehegen, die Sicht durch den Eiergang, den Zugang zur Trainingsstadt und die Anordnung der UI. Besonders die Stadt wirkt in den Illustrationen zu aufwendig und realistisch. Baue sie als helle, einfache Roblox-Stadt mit großen Farbflächen, blockigen Häusern und wenigen wiederverwendbaren Straßen- und Fassadenteilen.

Die Trainingsstadt soll sich beim Fahren groß anfühlen. Dafür reichen verbundene Straßenzüge, gut erkennbare Kreuzungen und eine Runde zurück zum Ausgangspunkt. Ein farbiges Schild und ein markantes Gebäude können den Heimweg zeigen. Die Hafenkräne, Schiffe, Skyline, einzelnen Ziegel und aufwendigen Lichteffekte gehören zur Illustration. Für die erste Version genügen breite Straßen, einfache Beleuchtung und wenige Orientierungspunkte.

## Was zuerst gebaut wird

1. Lies das [Spielkonzept](docs/SPIELKONZEPT.md). Darin stehen die verbindlichen Mechaniken, Valentins Beispiel für Rebirth 2 und die offenen Balancewerte.
2. Öffne die [Bildgalerie](docs/design/README.md). Bilder 01 und 02 erklären Gehegehof und Eiergang. Bilder 03 und 09 zeigen Fahransicht und Straßennetz der Trainingsstadt. Bilder 04 bis 08 zeigen Shop, Sammlung, Eierpanel, Modelle und Gehegeplätze.
3. Baue zuerst einen fahrbaren Kukurin und einen vollständigen Weg vom Gehege zum Ei und zurück. Prüfe danach Tiereinkommen, Ausbau und den ersten Rebirth. Ergänze die zweite Welt mit demselben Spielerfortschritt. Die einzelnen Prüfschritte stehen im [Entwicklungsplan](docs/ENTWICKLUNGSPLAN.md).

## Hinweise zur Umsetzung

- Beim Eiergang die [Regeln für Beute und Wächter](docs/SPIELKONZEPT.md#eier-stehlen-im-stage-gang) umsetzen. Ein Wächter muss seinen Spieler durch die Grenzen anderer Stages verfolgen können. Die Grenze zur Safe Zone am Gehegehof beendet die Jagd. Nach einem Fang läuft das Tier zurück in seine Heimatstage.
- Beim Training nur tatsächlich gefahrene Strecke berücksichtigen. Weltwechsel und Teleports aus der Streckenmessung ausnehmen. Den Wheelie-Bonus nur für den Abschnitt mit angehobenem Vorderrad vergeben.
- Rebirths setzen Speed, Fahrlevel und die laufende Trainingsleiste auf Startwerte. Die Tiere bleiben erhalten, das Training wird schneller und das Modell des erreichten Meilensteins wird genau einmal kostenlos vergeben.
- Anzeigen aus den aktuellen Spielerdaten befüllen. Große Schaltflächen, ein lesbarer Trainingsbalken und ein gut erreichbares X für geöffnete Menüs sollen auf Handy und PC funktionieren. Robux-Angebote im Shop und Gehegeausbau mit Spielgeld haben eigene Aktionen.
- Käufe, Freischaltungen, Platzbelegung und Einkommen auf dem Server prüfen. Fortschritt beim Weltwechsel und Wiederbeitritt testen. Geprüfte Arbeit im Repository sichern.
