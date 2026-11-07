# Kukurin: Stadtentwürfe für Claude Code

Diese acht Bilder bearbeiten die acht unterschiedlichen Original-Screenshots von Steal an Egg für **Ride a Kukurin to Steal an Egg**. Sie sind mit dem integrierten Imagegen-Werkzeug erstellt. Die Originale bleiben unverändert unter `references/steal-an-egg/screenshots/`. Die Kristallspiel-Entwürfe aus dem anderen Repository wurden nicht verwendet.

## Bilder

| Stadtentwurf | Zweck |
| --- | --- |
| [01 – Mapübersicht](01-map-overview-city-v1.png) | Hoher schräger Blick, Stadtfassaden, Straßen und umzäunte Tierflächen; gemeinsame Stilreferenz. |
| [02 – Haustier-Index](02-collection-index-city-v1.png) | Haustiersammlung im Cyan-Fenster, Kartenraster und Einzelansicht. |
| [03 – Kukurin-Shop](03-kukurin-shop-city-v1.png) | Modellkauf gegen Spielgeld im grünen Fenster. |
| [04 – Eierpanel](04-egg-side-panel-city-v1.png) | Ausklappbares rechtes Ei-Fenster über der Stadtmap. |
| [05 – Stadtverlauf](05-map-progression-city-v1.png) | Basenhof und gerade nach hinten führende Straße mit verschiedenen Stadtabschnitten. |
| [06 – Kukurin-Upgrades](06-kukurin-upgrades-city-v1.png) | Übertragung des dreispaltigen Trail-Fensters auf Scooter-Upgrades. |
| [07 – Upgradeplatz](07-scooter-station-city-v1.png) | Kukurin-Station anstelle des Laufbands; Nachbarschaft zu Tierbasis und Rangliste. |
| [09 – Tierbasis](09-base-upgrade-city-v1.png) | Spielersicht auf Zauneingang, Tiereinkommen und Basisverbesserung. |

Es gibt kein Bild 08: Die Originalnummer 08 war eine identische Kopie von 06. Die Nummerierung wurde für den Vergleich beibehalten.

## So umsetzen

Die kräftigen Farben, einfachen blockigen Stadtgebäude, Asphaltwege, Gehwege und schwarz-orangen Scooter übertragen. Die rechteckigen Tierflächen, Hofstruktur und die gerade Zonenfolge bleiben erkennbar. Die Bilder sind Ansichten derselben Grundidee, keine acht verschiedenen Maps. Für einen konsistenten Grundriss zuerst die Originalansichten 01 und 05 mit den Stadtfassungen vergleichen. KI-generierte kleine Abweichungen in Grundstückspositionen und Häusern nicht als zusätzliche Orte bauen.

Menüs und Anzeigen als funktionierende Roblox-UI bauen. Bildpreise, Level, Scooter-Modellnamen und Geschwindigkeiten sind Beispiele und keine endgültige Balance. „Kukurin“ ist der verbindliche Namensbestandteil, „Starter“, „City“ und „Pro“ sind illustrative Modellnamen.

## Spätere Gameplay-Entscheidung hat Vorrang

Die Bildaufträge liefen bereits, als Valentin **Fahren als Speed-Training** bestätigte: Aktive gefahrene Strecke trainiert Speed; spätere Stufen brauchen mehr Strecke; Stillstand zählt nicht. Tiere erzeugen Geld/s und finanzieren bessere Kukurin. Speed-Stufen bleiben beim Modellwechsel erhalten.

Die Bilder zeigen noch keine Fahrtrainingsleiste. Claude ergänzt eine kleine Leiste beim Scooter-HUD. Die reinen Geld-Upgrade-Beispiele in 03, 06 und 07 dürfen Fahrtraining nicht vollständig ersetzen. Das genaue Verhältnis von Training, Modellgrenzen und Geld-Upgrades steht als einfache Konfiguration noch aus.

## Bekannte Bilddetails für die Umsetzung

- „Geschäft“ und „Kukurin“ variieren als Beschriftung des grünen linken Zugangs. Einheitlich „Kukurin“ mit Scooter-Symbol verwenden.
- In einzelnen Bildern ist der ursprüngliche Schalter „Langsamer Modus“ noch sichtbar. Daraus keinen zweiten persönlichen Speed-Fortschritt oder zusätzlichen Pflichtmodus bauen.
- Shopkarten und HUD zeigen unabhängige Beispielwerte. Beispielsweise darf im fertigen Spiel ein ausgerüsteter 25-km/h-Scooter nicht ohne erklärte Trainings-/Modellberechnung als 40 km/h angezeigt werden. Alle Anzeigen aus denselben Daten berechnen.
- Tier-Index und Ei-Panel zeigen die Optik. Sammlungsbelohnungen, Ei-Wachstumszeiten, Tierkapazität und Basis-Upgrades sind dadurch noch nicht abschließend festgelegt.
- Rangliste, dekorative Stände und sonstige Extras hinter dem vollständigen Kernablauf priorisieren.

Die genaue Bildherkunft und Einzelaufträge stehen in [PROMPTS.md](PROMPTS.md). Die Beschreibung von Originalaufbau, HUD-Positionen und Übertragung steht in [VISUELLE_REFERENZ.md](../VISUELLE_REFERENZ.md).
