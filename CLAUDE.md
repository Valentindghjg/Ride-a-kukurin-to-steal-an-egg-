# Einstieg für Claude Code

Projekt: **Ride a Kukurin to Steal an Egg**. Kukurin bleibt im Namen. Kurze Entwicklungszeit, einfache Logik und ein kleiner spielbarer Kern haben Vorrang.

## Zuerst lesen und Bilder öffnen

1. AGENTS.md und README.md.
2. docs/SPIELKONZEPT.md und docs/ENTWICKLUNGSPLAN.md.
3. docs/VISUELLE_REFERENZ.md und docs/design/README.md.
4. Die dort verlinkten PNGs tatsächlich mit einem Bildwerkzeug ansehen. Die Originale und die Stadtentwürfe zeigen verschiedene Zustände derselben Vorlage.

## Verbindlicher Kern

Tiere im Gehege verdienen Geld für Gehegeplätze und Upgrades am aktuellen Scooter. Bessere Kukurin werden beim jeweiligen Rebirth automatisch und kostenlos freigeschaltet.

Aktive Fahrt füllt die Trainingsleiste. Der Server zählt plausibel gefahrene Strecke. Mit jeder vollen Leiste steigt das Fahrlevel und damit der trainierte Speed.

Zwei Welten verwenden denselben Fahrfortschritt. In der Hauptwelt führt der Weg von den Gehegen durch den langen Gang zu den Tieren und Eiern. Die große Trainingsstadt erlaubt freies Fahren und Speed-Training ohne Eierdiebstahl. Beim Wheelie gewinnt der Spieler pro gefahrenem Streckenabschnitt mehr Training. Beim Übergang zwischen den Welten den Positionssprung aus der Streckenmessung ausnehmen.

Sobald das erforderliche Fahrlevel erreicht ist, kann der Spieler einen Rebirth auslösen. Speed, Fahrlevel und die laufende Leiste beginnen beim Startwert. Im neuen Durchgang bringt dieselbe gefahrene Strecke mehr Trainingsfortschritt. Tiere bleiben erhalten. Der Trainingsbonus und ein möglicher Einkommensbonus sind getrennte Werte. Rebirth 2 mit neuem Modell und 5 % mehr Tiereinkommen ist ein Beispiel. [Spielkonzept](docs/SPIELKONZEPT.md#so-spielt-sich-eine-runde)

Beim Nachbau von Bild 03 auf jeder Modellkarte den benötigten Rebirth oder „Freigeschaltet“ anzeigen. Die Modellvergabe erfolgt direkt beim Rebirth. Eine kleine Leiste beim Scooter-HUD zeigt den Trainingsfortschritt.

Der Robux-Shop ist ein eigener HUD-Zugang. Im geöffneten Menü erscheinen Artikel, Wirkung und Robux-Preis sowie eine Schließen-Schaltfläche. Produkte und Preise sind noch offen. Den Ablauf für Weltwechsel, Wheelie und Shop im [Spielkonzept](docs/SPIELKONZEPT.md#trainingsstadt-und-wheelies) nachlesen. Für die nächste Bildserie liefert Valentin neue Fotos.

Keine Kristalle, Grabkraft, Trainingssteine, Werkzeuge, Minen oder Maulwürfe aus dem separaten Projekt Steal a Crystal übernehmen. Auch dessen zwölf Stages und zwölf Werkzeuge sind keine Vorgabe für dieses Spiel.

## Welche Bilder gelten?

- `references/steal-an-egg/screenshots/`: acht unveränderte Originalansichten von Steal an Egg. Zeigen den Ausgangsaufbau von Map und UI.
- `docs/design/*-city-v1.png`: KI-bearbeitete Stadtentwürfe für dieses Kukurin-Spiel. Zeigen die gewünschte Übertragung auf Straßen, Gehwege, einfache Häuser und Scooter.
- Im Quellrepository Steal-a-Crystal liegen unter `docs/design/` bearbeitete Kristallspiel-Bilder. Diese sind NICHT Vorlagen für dieses Projekt und wurden nicht importiert.

## Umsetzung

Die räumliche Grundstruktur der Originale erhalten: eingezäunte Basen um einen gemeinsamen Hof, ein zentraler Ausgang in eine gerade Zonenfolge. Als Stadt gestalten und für Scooter befahrbar halten. Eier/Tiere und ihre Basisflächen bleiben erkennbar.

HUD und Menüs aus echten Roblox-UI-Elementen bauen. PNGs sind Referenzbilder, keine komplette Oberfläche zum Einblenden. Geld und Scooter-Fortschritt aus denselben tatsächlichen Spielerdaten anzeigen. KI-Bildtexte, Beispielpreise, Level, Mengen und Geschwindigkeiten sind keine verbindliche Balance. Unterschiedliche Bilder sind unabhängige Beispielzustände.

Nur der kleine Kern muss zuerst funktionieren. Sichtbare Extras wie Trails, Premium-Eier, Events und Sammlungsbelohnungen sind keine automatische Aufforderung, diese Systeme zu bauen. Laufzeitregeln sind nicht aus Screenshots bewiesen. Routinewerte einfach wählen und dokumentieren, ohne ein großes Planungssystem aufzubauen.

Nach Änderungen passende Funktionsprüfung durchführen, CHANGELOG.md aktualisieren und den Stand in diesem Repository speichern. Keine erfolgte Studio-Prüfung behaupten, solange sie nicht tatsächlich durchgeführt wurde.
