# Spielkonzept

Stand: 7. November 2026. Grundlage: Valentins Spielbeschreibung und Präzisierung zum kleinen Entwicklungsumfang.

## Festgelegte Richtung

- Roblox-Spiel mit dem Arbeitstitel „Ride a Kukurin to Steal an Egg“.
- E-Scooter sind das zentrale Fortbewegungsmittel.
- Das Grundspiel orientiert sich an Steal an Egg: Eier stehlen und Geld für Fortschritt verwenden.
- Statt persönlicher Speed-Upgrades verbessert der Spieler seinen Scooter.
- Zusätzlich lassen sich bessere Scooter-Modelle kaufen.
- Spätere Modelle kosten zunehmend mehr Geld und sollen längerfristige Ziele sein.
- Räumlicher Mapaufbau und Eier sollen sich eng an der Referenz orientieren. Neue Präzisierung: gleicher 3D-Grundaufbau, aber als Stadt gestaltet. Acht Originalansichten und neue Stadtentwürfe sind im Repository erfasst; siehe VISUELLE_REFERENZ.md und design/README.md. Die vollständige Eierliste und Werte bleiben offen.
- Alle Projektarbeit soll fortan in diesem Repository gespeichert werden.
- **Kukurin** ist die verbindliche Schreibweise und ein wichtiger Bestandteil des Spielnamens. Valentin nennt den aktuellen Roblox-Hype als Grund.
- Kurze Entwicklungszeit hat Priorität. Gewünscht ist ein einfaches Spiel mit überschaubarer Logik; kein großes, aufwendig ausgearbeitetes Projekt.

## Umfang der ersten Version

Der erste Stand konzentriert sich auf den vollständigen Kernablauf mit einer kompakten Map, einfacher Scooter-Steuerung, wenigen Eiern und wenigen Scooter-Modellen. Konkrete Mengen sind noch offen. Für die erste Umsetzung reichen einfache Modelle und eine zweckmäßige Oberfläche. Aufwendige Fahrzeugphysik, zusätzliche Spielmodi und umfangreicher Feinschliff werden zurückgestellt. Diese Umsetzungslinie folgt Valentins Vorgabe, die Entwicklung kurz zu halten.

## So spielt sich eine Runde

| Funktion | Verhalten im Spiel |
| --- | --- |
| Start und Map | Der Spieler startet mit einem einfachen Kukurin im gemeinsamen Basenhof. Um den Hof liegen eingezäunte Tiergehege. Eine gerade Straße führt durch mehrere Stadtabschnitte zu den Eiern. |
| Fahrtraining | Aktiv gefahrene Strecke füllt die Trainingsleiste. Jede volle Stufe erhöht das Fahrlevel und verbessert den Speed auf dem Scooter. Spätere Stufen brauchen mehr Strecke. Stillstand bringt keinen Fortschritt. |
| Eier stehlen | Der Spieler fährt zu einem Ei und bringt es zur eigenen Basis. Mehr Speed hilft, entferntere und bessere Eier zu holen. Gegner, Fangregeln und der genaue Moment, in dem die Beute sicher ist, stehen noch aus. |
| Tiere und Einkommen | Aus gestohlenen Eiern kommen Tiere. Jedes im Gehege platzierte Tier trägt seinen Geldbetrag pro Sekunde zum Einkommen bei. Schlüpfzeit, Werte je Tier und das Abholen des Geldes sind offen. |
| Gehege ausbauen | Die Zahl der gleichzeitig platzierten Tiere ist begrenzt. Der Spieler gibt einen größeren Betrag Spielgeld für zusätzliche Plätze aus. Erst ein zusätzlich eingesetztes Tier erhöht den Ertrag. Startgröße, Preise und Plätze je Ausbau folgen im Spieltest. |
| Kukurin verbessern | Mit Spielgeld lässt sich der eigene Scooter verbessern oder ein teureres Modell kaufen. Bessere Modelle ermöglichen höheren Speed. Beim Wechsel des Modells behält der Spieler sein trainiertes Fahrlevel. |
| Rebirth | Sobald der Spieler das benötigte Fahrlevel erreicht, kann er einen Rebirth auslösen. Seine Tiere behält er. Bestimmte Rebirths können direkt einen besseren Kukurin geben und die Einnahmen der Tiere erhöhen. |

**Valentins Beispiel für den Spieltest.** Ab Fahrlevel 10 ist der erste Rebirth möglich. Beim Erreichen von Rebirth 2 erhält der Spieler einen besseren Kukurin und 5 % mehr Tiereinkommen. Verdienen die eingesetzten Tiere zusammen 100 Geld/s, werden daraus 105 Geld/s. Die 5 % beziehen sich auf das Einkommen. Eine pauschale Erhöhung bei jedem Rebirth ist noch offen.

**Offen beim Rebirth.** Ein möglicher Ablauf ist, das Fahrlevel für den nächsten Durchgang auf den Startwert zu setzen und gekaufte Gehegeplätze zu behalten. Fest zugesagt ist bislang der Erhalt der Tiere. Für Geld, gekaufte Modelle, Scooter-Upgrades und Plätze braucht es eine Reset-Regel. Weitere Levelziele und Boni werden nach der Fahrzeit abgestimmt.

**Oberfläche und Speicherstand.** Das HUD zeigt Scooter-Speed, Trainingsfortschritt und Geld. Der Shop zeigt Modelle und Upgrades, der Tier-Index die Sammlung. Am Gehegeschild sollen belegte Plätze, zusätzliche Plätze und Kaufpreis erkennbar sein. Beim Rebirth sollen benötigtes Fahrlevel, Belohnung und Reset vor dem Auslösen sichtbar sein. Für den Wiederbeitritt sind Tiere, Plätze, Geld, Scooter und Fortschrittswerte zu speichern.

## Vorgesehener Spielkreislauf

Mit dem Scooter losfahren → ein Ei stehlen → daraus Tiere für die Basis bekommen → Tiere erzeugen Geld pro Sekunde → Scooter verbessern oder auf ein besseres Modell sparen → bessere Eier erreichen und stehlen.

Valentin hat die zwei Komponenten bestätigt: Tiere liefern das Geld/s, Kukurin übernimmt den Speed-Fortschritt und ersetzt das Laufband. Genauer Schlüpfablauf, Einkommensabholung und Abschluss eines Diebstahls bleiben noch auszuarbeiten.

## Bestätigt: Fahren trainiert Speed

Valentin möchte zusätzlich zum Geldbedarf einen zeitabhängigen Fortschritt wie beim Laufband des Vorbilds. Reiner Modellkauf soll nicht sofort den gesamten Speed-Fortschritt überspringen.

Valentin hat den Vorschlag bestätigt („bissl so wie keyboard escape … gefällt mir“): Echte gefahrene Strecke füllt automatisch eine Trainingsleiste und erhöht Speed-Stufen. Spätere Stufen benötigen mehr Strecke; Stillstand gibt keinen Fortschritt. Tiere finanzieren bessere Modelle, Fahren trainiert die Geschwindigkeit. Bessere Modelle bieten mehr erreichbare Geschwindigkeit, erfahrene Stufen bleiben beim Modellwechsel erhalten. Keine zusätzliche Treibstoff-, Hunger- oder Ausdauerwirtschaft nötig. Keyboard Escape ist Valentins Vergleich für den Fortschrittsansatz; dessen Details wurden nicht untersucht und sind keine weitere Bauvorlage.

Vor Umsetzung die einfache Beziehung zwischen Fahrtraining, Modellgrenzen und Geld-Upgrades festlegen. Bei streckenbasiertem Training auch berücksichtigen, dass schnellere Modelle Strecke schneller sammeln. Noch keine verbindliche Formel oder Trainingsdauer. Die Stadtbilder wurden vor dieser Bestätigung beauftragt; ihnen fehlt noch die Trainingsleiste. Deren reine Kauf-/Upgrade-Ansichten überschreiben diese bestätigte Mechanik nicht.

## Scooter-Fortschritt

Zwei Ausgaben sollen sich sinnvoll ergänzen:

1. Den aktuellen Scooter mit Geld verbessern.
2. Geld für einen besseren, teureren Scooter sparen.

Noch offen sind Modellnamen, Anzahl der Modelle, Upgrade-Stufen, Fahrwerte, Preise und die gewünschte Spieldauer bis zum nächsten Kauf. Es gibt noch keine verbindliche Preistabelle.

## Vor Umsetzung zu konkretisieren

- Exakter Link zur gemeinten Steal-an-Egg-Erfahrung für spätere Live-Prüfung, falls nötig. Visuelle Originalreferenzen liegen bereits lokal vor und blockieren die Umsetzung nicht.
- Genaue Titelformulierung; **Kukurin** bleibt als Bestandteil festgelegt.
- Fahrgefühl: Steuerung, Beschleunigung, Bremsen, Kurven und Verhalten beim Tragen eines Eis.
- Diebstahlregeln, Einkommen je Tier, Eierwerte und mögliche Seltenheiten.
- Kartenabmessungen und Anordnung der Spielbereiche.
- Start-Scooter, Upgrade-Wirkung, Modellfolge und Preiskurve.

Diese offenen Punkte sind keine zusätzlich beschlossenen Features. Zahlen und Mechaniken werden erst bei ihrer Ausarbeitung festgelegt.
