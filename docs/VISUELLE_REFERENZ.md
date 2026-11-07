# Map und UI: Vorlage für Claude Code

Stand: 7. November 2026. Die acht unterschiedlichen Originalansichten wurden visuell geprüft. Sie stammen aus `references/screenshots/` im Repository Steal-a-Crystal. Dessen Kristallspiel-Entwürfe und dessen Spielregeln gelten hier nicht.

## Bilderübersicht

| Original | Sichtbare Referenz | Übertragung auf Kukurin |
| --- | --- | --- |
| [01 Mapübersicht](../references/steal-an-egg/screenshots/01-map-overview.png) | Hoher schräger Blick auf grüne rechteckige umzäunte Grundstücke, gemeinsame Wege, Stände und hohe braune Außenwände. | Grundstückspositionen und Hofaufbau erhalten; Wege zu Stadtstraßen mit Gehwegen machen, einfache Häuser am Rand, Kukurin-Stand. |
| [02 Haustier-Index](../references/steal-an-egg/screenshots/02-collection-index.png) | Großes Cyan-Fenster, links Wald-Kategorie, mittig zwei Reihen Tierkarten, rechts Einzelansicht und Belohnung, unten Fortschritt. | Tier-/Eiersammlung beibehalten. Kein Kristall- oder Werkzeug-Index. Speed-Belohnungen nicht als zweiten persönlichen Fortschritt übernehmen. |
| [03 Geschäft](../references/steal-an-egg/screenshots/03-premium-shop.png) | Grüner Titel, dunkle Inhaltsfläche, Karten und rotes X. | Das Kartenlayout als Modellübersicht verwenden. Jede Karte zeigt den erforderlichen Rebirth oder das freigeschaltete Modell. |
| [04 Ei-Seitenpanel](../references/steal-an-egg/screenshots/04-egg-side-panel.png) | Rechter ausklappbarer Kasten, beige Kopfzeile „Wachsende Eier“, gelber Sammelknopf, dunkle leere Liste, roter Randpfeil. | Position und Ei-Thema erhalten. Wachstumszeiten und genaue Bedeutung von „Alle anbauen“ sind aus dem Bild nicht ableitbar. |
| [05 Zonenverlauf](../references/steal-an-egg/screenshots/05-map-progression.png) | Vorderer Basenhof, mittiger Ausgang, lange gerade Folge verschieden gestalteter Bereiche zwischen Seitenwänden. | Gleiche Hauptrichtung; Stadtdistrikte entlang einer geraden Straße. Keine freie Großstadt mit verzweigtem Straßennetz daraus machen. |
| [06 Trail-Shop](../references/steal-an-egg/screenshots/06-trail-shop.png) | Violetter Titel, drei hohe Karten in Grau/Grün/Blau, große Motive, Werte und grüne Aktionen. | Kartenlayout als einfacher Kukurin-Upgrade-Shop. Trails und deren Multiplikatoren sind keine beschlossene Funktion. |
| [07 Stationen](../references/steal-an-egg/screenshots/07-training-and-upgrades.png) | Laufband links, Verbesserungsschild, kostenlose Truhe, blaue Geld/s-Rangliste an der Wand, Zaun rechts. | Laufband durch Kukurin-Upgradeplatz mit Scooter und Schild ersetzen. Tiere/Geld/s bleiben; Truhe und Rangliste sind optionale Extras. |
| [09 Basis](../references/steal-an-egg/screenshots/09-base-upgrade.png) | Blick durch Eingang eines gelb umzäunten Geheges, linkes Verbesserungsschild mit Stufe/Preis, grüne Geldzahlen im Gehege. | Tiergehege erhalten, außen Gehweg/Straße und Häuser. Spieler fährt Kukurin. Der Kauf am Schild erhöht die Zahl der gleichzeitig platzierbaren Tiere. Preis und Plätze je Stufe sind noch offen. |

## Map: räumlichen Aufbau erhalten

Die beiden Hauptansichten sind **01** für die Grundstücksanordnung und **05** für den Verlauf vom Hof zu den Zonen. Bild 09 liefert den Eingang und die Zaunhöhe aus Spielersicht. Bild 07 zeigt die räumliche Nachbarschaft der Stationen.

- Ausgangspunkt ist ein breiter gemeinsamer Hof mit rechteckigen, niedrigen, eingezäunten Spielerflächen und offenen Eingängen. Besitzerporträts bzw. Hausmarker schweben über den Flächen.
- Am Rand zum Ausgang liegen kleine Stände, eine Rangliste und Stationen. Ihre relative Lage aus den Bildern übernehmen, wenn sie für den Kern benötigt werden.
- Ein mittiger Ausgang führt in einen langen, geraden Streifen mit mehreren optisch getrennten Bereichen. Die Bilder liefern keine gesicherte Gesamtzahl oder Maße.
- Die Vorlage verwendet helle grüne Noppen-/Kachelböden, gelbe/braune Zäune, hohe braune Wände und blauen Himmel. Das neue Thema ersetzt die kahlen Randwände durch einfache farbige Stadtfassaden und die gemeinsamen Wege durch Asphalt und Gehwege. Die Tierflächen dürfen grün bleiben.
- Straßen und Basiseingänge müssen breit genug für den Scooter sein. Den gleichen Grundriss verwenden; exakte Stud-Maße sind Implementierungswerte. Keine komplexe Fahrzeugwelt oder Verkehrssimulation ergänzen.

## HUD: Position und Erscheinung

Die Originale sind ungefähr 1920 × 1080. Die folgenden Positionen sind gerundete Proportionen als Nachbauhilfe, keine Pixelpflicht:

| Bereich | Position im Original | Kukurin-Übertragung |
| --- | --- | --- |
| Hauptzugänge | Links bei etwa 1–11 % Breite und 40–55 % Höhe, zwei große Buttons übereinander. | Der grüne Kukurin-Button öffnet die Modellübersicht und Upgrades, der cyanfarbene den Index. |
| Langsamer Modus | Direkt unter linken Hauptzugängen. | Im ersten Entwurf weggelassen; kein zusätzlicher persönlicher Speed-Fortschritt. Eine spätere Fahrbegrenzung wäre gesondert zu entscheiden. |
| Werte | Links unten etwa 1–18 % Breite und 86–99 % Höhe. Gelbe Speed-Zahl über grüner Geldzahl. | Scooter-Symbol und Scooter-Geschwindigkeit statt Schuh/Lauf-Speed. Geld bleibt darunter. Geld/s stammt aus den Tieren; zusätzliche Gesamtanzeige ist bei Bedarf möglich. |
| Verwaltung | Rechts außen bei etwa 95–99 % Breite, mittig; Ei rot, Pfote orange. | Ei-/Tierzugänge behalten. Pfotenfunktion ist in den Originalen nicht geöffnet. |
| Seitenpanel | Rechts etwa 77–99 % Breite und 35–68 % Höhe. | Ei-Verwaltung in derselben Position, einklappbar. |
| Hotbar | Unten mittig bei ungefähr 47–53 % Breite. | Nur tatsächlich benötigte Slots. Die zwei Originalgegenstände und ihre Regeln sind nicht belegt. |
| Ereignisfigur/Timer | Rechts unten. | Für den kleinen Kern entfallen; keine Eventlogik daraus ableiten. |

Roblox-Systemleiste oben links und Desktop-Titelleiste sind keine selbst zu bauende Spiel-UI. Usernamen, Chatmeldungen und Original-Spielstände nicht fest einbauen.

## Menügestaltung

Große mittige Fenster nehmen ungefähr 60 % der Bildschirmbreite ein. Titelbalken sind kräftig gefärbt, der Inhalt dunkelgrau/violett mit dezentem Noppenmuster. Breite dunkle Umrandungen und große weiße Schrift mit schwarzer Kontur erzeugen die typische Roblox-Wirkung. Der rote quadratische Schließenknopf sitzt oben rechts. Die Spielwelt bleibt sichtbar und ist hinter geöffneten Hauptmenüs unscharf.

Der Index zeigt Kategorien, Tierkarten, Einzelansicht und Sammlungsfortschritt. Im Kukurin-Fenster erhält jede Modellkarte ein Scooterbild, die Leistung und den zugehörigen Rebirth. Der Upgrade-Tab zeigt Preis und Wirkung der Verbesserung am aktuellen Scooter.

Für Handy mit relativen Größen und Layouts arbeiten: Bewegung und Kamera freihalten, Menüs innerhalb des sichtbaren Bereichs halten, nötigenfalls scrollen. Die Originale zeigen nur PC; sie beweisen keine mobile Anordnung.

## Spiellogik und Bildinhalt unterscheiden

Tiere in der Basis erzeugen Geld pro Sekunde. Aktive Fahrt trainiert Speed. Ein Rebirth setzt Speed und Fahrlevel auf die Startwerte und beschleunigt das weitere Training. Neue Kukurin gibt es bei den entsprechenden Rebirths. Das HUD braucht eine kleine Trainingsleiste.

Nicht durch die Bilder geklärt: genauer Schlüpf-/Wachstumsablauf, Wächterverhalten, Zonenanforderungen, Verhalten bei vollem Gehege, Preise für zusätzliche Plätze und Einkommensabholung. Die neuen Bilder sind visuelle Entwürfe und entscheiden diese Regeln nicht. Preise, Scooterwerte und Tiermengen sind Beispiele. Keine Crystal-Regeln aus dem Quellprojekt importieren.
