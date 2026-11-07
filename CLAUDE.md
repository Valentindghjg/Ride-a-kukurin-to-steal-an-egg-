# Einstieg für Claude Code

Projekt: **Ride a Kukurin to Steal an Egg**. Kukurin bleibt im Namen. Kurze Entwicklungszeit, einfache Logik und ein kleiner spielbarer Kern haben Vorrang.

## Zuerst lesen und Bilder öffnen

1. AGENTS.md und README.md.
2. docs/SPIELKONZEPT.md und docs/ENTWICKLUNGSPLAN.md.
3. docs/VISUELLE_REFERENZ.md und docs/design/README.md.
4. Die dort verlinkten PNGs tatsächlich mit einem Bildwerkzeug ansehen. Die Originale und die Stadtentwürfe zeigen verschiedene Zustände derselben Vorlage.

## Verbindlicher Kern

Zwei zusammenhängende Fortschritte: Tiere in der Basis erzeugen Geld pro Sekunde. Das Geld verbessert den Kukurin oder kauft ein schnelleres Modell. Der Kukurin ersetzt Laufband und persönliche Speed-Upgrades und hilft, bessere Eier zu erreichen und zu stehlen. Eier und Tiere bleiben erhalten.

Zusätzlich bestätigt: **Aktives Fahren trainiert Speed**. Echte gefahrene Strecke füllt eine Trainingsleiste und erhöht Speed-Stufen; spätere Stufen benötigen mehr Strecke, Stillstand zählt nicht. Bessere Modelle bieten mehr erreichbare Geschwindigkeit; trainierte Speed-Stufen bleiben beim Wechsel erhalten. Die genaue Formel und das Verhältnis zu Geld-Upgrades einfach als Konfigurationswerte festlegen. Käufe allein dürfen das Fahrtraining nicht vollständig ersetzen. Server prüft echte Scooterbewegung; Teleports und unplausible Positionssprünge nicht als Trainingsstrecke belohnen.

Rebirths hängen vom erreichten Fahrlevel ab. Tiere bleiben beim Rebirth erhalten. Als Beispiel gibt es bei Rebirth 2 einen besseren Kukurin und 5 % mehr Tiereinkommen. Der teure Gehegeausbau erhöht die Zahl der gleichzeitig platzierbaren Tiere. Die Zusammenfassung im [Spielkonzept](docs/SPIELKONZEPT.md#so-spielt-sich-eine-runde) beschreibt den Ablauf, die Beispielwerte und die offenen Reset-Regeln.

Die acht Stadtbilder wurden vor der Bestätigung des Fahrtrainings beauftragt. Eine kleine Trainingsleiste beim Scooter-HUD ergänzen; die dort gezeigten Kaufstufen sind Beispiele, keine vollständige Progressionsspezifikation.

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
