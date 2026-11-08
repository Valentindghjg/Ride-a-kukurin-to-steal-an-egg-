# Ride a Kukurin to Steal an Egg

**Ziel der ersten Version** ist ein schnell umsetzbares Roblox-Spiel mit einem einfachen Kukurin, wenigen thematischen Stages und einem erreichbaren Rebirth. Das Spielgefühl, die Gehege und die gerade Folge von Eierzonen orientieren sich an *Steal an Egg*. Das Fahrtraining auf dem Kukurin übernimmt die Rolle des Laufbands.

## So spielt sich eine Runde

Der Spieler startet mit einem einfachen Kukurin am eigenen Gehege. Er fährt durch das Tor in den langen Eiergang, stiehlt ein Ei und bringt es zurück. Durch die Fahrt steigt sein Speed. Dadurch kann er entferntere und bessere Eier erreichen und schneller mit ihnen zurückkehren. Aus den Eiern kommen Tiere, die im Gehege Geld pro Sekunde verdienen.

| Mechanik | Spielregel |
| --- | --- |
| Fahrtraining | Aktiv gefahrene Strecke füllt die Trainingsleiste. Eine volle Leiste erhöht Fahrlevel und trainierten Speed. Innerhalb eines Durchgangs benötigen spätere Level mehr Strecke. Stillstand bringt keinen Fortschritt. |
| Tiereinkommen | Jedes eingesetzte Tier liefert seinen eigenen Geldbetrag pro Sekunde. Das Gesamteinkommen ist die Summe der aktiven Tiere mit dem jeweils freigeschalteten Einkommensbonus. |
| Gehegeausbau | Das Gehege hat begrenzt Platz. Mit einem größeren Betrag Spielgeld kauft der Spieler zusätzliche Plätze für gleichzeitig aktive Tiere. Das Einkommen steigt, wenn ein weiteres Tier eingesetzt wird. |
| Scooter-Upgrades | Mit Spielgeld kann der Spieler seinen aktuellen Kukurin verbessern. Neue Modelle erhält er automatisch und kostenlos bei den vorgesehenen Rebirth-Meilensteinen. Bessere Modelle ermöglichen höheren Speed. |
| Rebirth | Ab dem nötigen Fahrlevel kann der Spieler einen Rebirth auslösen. Speed und Fahrlevel gehen auf die Startwerte zurück und die laufende Leiste leert sich. Die Tiere bleiben erhalten. Bei gleicher Strecke levelt der Spieler im neuen Durchgang schneller. |

**Valentins Beispiel für die Balance.** Der erste Rebirth könnte ab Fahrlevel 10 möglich sein. Bei Rebirth 2 könnte der Spieler einen besseren Kukurin und 5 % mehr Tiereinkommen bekommen. Aus 100 Geld/s würden 105 Geld/s. Der Einkommensbonus und das schnellere Leveln nach einem Rebirth sind zwei verschiedene Belohnungen.

## Eier stehlen im Stage-Gang

Jede Stage hat ein eigenes Thema, zum Beispiel Wald. Pro Stage gibt es fünf verschiedene Tierarten zum Sammeln, fünf zum Thema passende 3D-Eiermodelle und ein Tier, das die Stage bewacht.

Die Größe eines Eis lässt schon vor dem Aufheben erkennen, wie schwer der Rückweg wird. Je größer das Ei, desto schwerer ist es. Je mehr es wiegt, desto langsamer fährt derselbe Kukurin, solange der Spieler es trägt. Aus einem schwereren Ei schlüpft ein schwereres Tier. Ein schwereres Tier verdient im Gehege mehr Geld pro Sekunde.

Je weiter hinten eine Stage im Gang liegt, desto schneller ist ihr Wächter. Verfolgt er einen Spieler, läuft er auch durch fremde Stages. Auf dem Rückweg endet die Verfolgung an der Safe Zone, wo der Gang in den Gehegehof mündet. Holt der Wächter den Spieler vorher ein und fängt ihn, läuft er zu seiner eigenen Stage zurück. Was beim Fang mit Spieler und Ei passiert, ist noch offen.

## Trainingsstadt und Wheelies

Vom Gehegehof gibt es einen eigenen Zugang zu einer zweiten Welt. Dort fährt der Spieler frei durch eine große Stadt und trainiert Speed, auch wenn er gerade keine Eier stehlen will. Der Rückweg führt zum Hof. Der ausgerüstete Kukurin, das Fahrlevel, die Trainingsleiste und der Rebirth-Stand werden zwischen beiden Welten geteilt. Der Weltwechsel selbst gibt keine Trainingsstrecke.

Bei einem Wheelie bleibt das Hinterrad auf der Straße und das Vorderrad hebt ab. Für den tatsächlich so gefahrenen Abschnitt wächst die Trainingsleiste stärker als für eine gleich lange normale Fahrt. Sobald das Vorderrad wieder aufsetzt, gilt die normale Rate. Die genaue Höhe des Bonus und seine mögliche Nutzung in der Hauptwelt sind offen.

## Map und Gestaltung

Die Hauptwelt hat einen breiten Hof mit rechteckigen Tiergehegen, gut sichtbaren Eingängen und einer mittigen Fahrspur. Geradeaus liegt das große Tor. Dahinter verläuft der lange Gang durch aufeinanderfolgende Tier- und Eierzonen. Der Zugang zur freien Trainingsstadt liegt seitlich und ist vom Zugang zum Eiergang zu unterscheiden.

Die neun Bilder sind als Vorlagen für Grundriss und UI freigegeben. Für die Stadt wünscht Valentin deutlich einfachere Roblox-Grafik. Breite Straßen, klare Farben, niedrige blockige Häuser und wiederverwendbare Gebäudeteile halten die Wege lesbar und den Bauaufwand klein. Die Größe der Trainingswelt entsteht durch den Platz zum Fahren und die Auswahl an Routen. [Bildgalerie](design/README.md)

## Robux-Shop und Menüansichten

- **Fahr-HUD.** Geschwindigkeit, Fahrlevel mit Trainingsleiste und Spielgeld sind während der Fahrt sichtbar. Beim Wheelie erscheint der Trainingsbonus an der Leiste.
- **Kukurin.** Modellkarten zeigen den ausgerüsteten Scooter und den benötigten Rebirth für weitere Modelle. Verbesserungen des aktuellen Scooters zeigen Wirkung und Spielgeldpreis. Vor dem Rebirth sieht der Spieler Voraussetzung, Reset und Belohnung.
- **Tier-Index und Eierpanel.** Der Index zeigt die Sammlung, unbekannte Tiere als Silhouetten und den Ertrag des ausgewählten Tiers. Über das seitliche Eierpanel sieht der Spieler seinen Eierbestand und weiterhin die Welt.
- **Gehegeschild.** Am Eingang stehen belegte und verfügbare Plätze, die zusätzlichen Plätze der nächsten Stufe und deren Spielgeldpreis.
- **Robux-Shop.** Ein eigener HUD-Button öffnet das Shopfenster über der Spielwelt. Eine Karte zeigt Artikel, Wirkung und Robux-Preis. Auswahl führt zur Kaufbestätigung, Abbruch zurück zum Shop und das X zurück ins Spiel. Produkte und Preise der Abbildung sind Beispiele.
- **Speicherung.** Tiere, Geld, Gehegeplätze, freigeschaltete und ausgerüstete Kukurin, Upgrades, Fahrlevel, laufender Trainingsfortschritt und Rebirth-Stand sollen beim Wiederbeitritt wieder verfügbar sein.

## Noch festzulegen

Die [vollständige Fragenliste](../offen/README.md) enthält die fehlenden Zahlen, Regeln für Sonderfälle und Entscheidungen für den ersten Spieltest.

- Stagethemen und konkrete Tierarten, Gestaltung und Gewicht der fünf Eiermodelle je Stage, Tempo mit Beute, Tiergewichte und Ertrag je Tier. Auch Schlüpfregeln, Einkommensabholung und Verhalten bei vollem Gehege sind offen.
- Wächterart und Tempo je Stage, Auslöser der Verfolgung, Folgen eines Fangs für Spieler und Ei sowie Zeitpunkt der Gutschrift bei erfolgreicher Flucht.
- Startlevel und Start-Speed, Fahrgefühl, Trainingskurve, Wheelie-Bonus, Scooter-Upgrades und ihre Preise.
- Modellfolge, Rebirth-Ziele und weitere Boni. Für Geld, Gehegeplätze und Scooter-Upgrades ist das Verhalten beim Rebirth noch offen.
- Startkapazität, zusätzliche Plätze und Kosten je Gehegestufe, Größe der Welten sowie Sortiment und Preise des Robux-Shops.
