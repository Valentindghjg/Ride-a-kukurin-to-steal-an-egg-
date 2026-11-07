# Spielkonzept

Stand: 7. November 2026. Grundlage: Valentins Spielbeschreibung und Präzisierung zum kleinen Entwicklungsumfang.

## Festgelegte Richtung

- Roblox-Spiel mit dem Arbeitstitel „Ride a Kukurin to Steal an Egg“.
- E-Scooter sind das zentrale Fortbewegungsmittel.
- Das Grundspiel orientiert sich an Steal an Egg: Eier stehlen und Geld für Fortschritt verwenden.
- Statt persönlicher Speed-Upgrades verbessert der Spieler seinen Scooter.
- Der Spieler erhält neue Kukurin kostenlos als Belohnung für bestimmte Rebirths.
- Spätere Modelle sind längerfristige Ziele mit entsprechend höheren Rebirth-Anforderungen.
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
| Trainingsstadt | Vom Basenhof aus kann der Spieler in eine zweite Welt wechseln. Dort fährt er mit seinem Kukurin frei durch eine große Stadt und trainiert denselben Speed wie in der Hauptwelt. Für das Training ist kein Ei nötig. Der Rückweg führt zum Basenhof. |
| Wheelie | Wer in der Trainingsstadt während der Fahrt das Vorderrad anhebt, bekommt für die im Wheelie gefahrene Strecke mehr Speed-Fortschritt. Beim Absetzen des Vorderrads geht das normale Training weiter. |
| Eier stehlen | Der Spieler fährt zu einem Ei und bringt es zur eigenen Basis. Mehr Speed hilft, entferntere und bessere Eier zu holen. Gegner, Fangregeln und der genaue Moment, in dem die Beute sicher ist, stehen noch aus. |
| Tiere und Einkommen | Aus gestohlenen Eiern kommen Tiere. Jedes im Gehege platzierte Tier trägt seinen Geldbetrag pro Sekunde zum Einkommen bei. Schlüpfzeit, Werte je Tier und das Abholen des Geldes sind offen. |
| Gehege ausbauen | Die Zahl der gleichzeitig platzierten Tiere ist begrenzt. Der Spieler gibt einen größeren Betrag Spielgeld für zusätzliche Plätze aus. Erst ein zusätzlich eingesetztes Tier erhöht den Ertrag. Startgröße, Preise und Plätze je Ausbau folgen im Spieltest. |
| Kukurin verbessern | Mit Spielgeld lässt sich der aktuelle Scooter verbessern. Sobald der Spieler den Rebirth-Meilenstein für ein neues Modell erreicht, erhält er diesen Kukurin automatisch. |
| Rebirth | Beim erforderlichen Fahrlevel kann der Spieler einen Rebirth auslösen. Sein trainierter Speed fällt auf den Startwert, das Fahrlevel beginnt von vorn und die Trainingsleiste leert sich. Im nächsten Durchgang levelt er bei gleicher Fahrstrecke schneller. Seine Tiere behält er. |
| Robux-Shop | Ein eigener Button im HUD öffnet Angebote mit Robux-Preisen. Nach dem Schließen sieht der Spieler wieder die freie Spielansicht. Die Produkte und Preise stehen noch aus. |

**Valentins Beispiel für den Spieltest.** Ab Fahrlevel 10 ist der erste Rebirth möglich. Beim Erreichen von Rebirth 2 erhält der Spieler einen besseren Kukurin und 5 % mehr Tiereinkommen. Verdienen die eingesetzten Tiere zusammen 100 Geld/s, werden daraus 105 Geld/s. Die 5 % beziehen sich auf das Einkommen. Eine pauschale Erhöhung bei jedem Rebirth ist noch offen.

**Offene Werte.** Die genaue Nummer des Startlevels, der Start-Speed, der Trainingsbonus je Rebirth und die weiteren Modell-Meilensteine stehen noch aus. Ob Geld, Scooter-Upgrades und Gehegeplätze beim Rebirth erhalten bleiben, ist ebenfalls offen.

**Oberfläche und Speicherstand.** Das HUD zeigt Scooter-Speed, Trainingsfortschritt und Geld. Modellkarten zeigen den erforderlichen Rebirth oder die bereits erreichte Freischaltung. Der Tier-Index zeigt die Sammlung. Am Gehegeschild stehen Belegung, zusätzliche Plätze und Kaufpreis. Vor einem Rebirth sieht der Spieler das benötigte Level, den Reset und die Belohnung. Beim Wiederbeitritt werden Rebirth-Stand, Fahrtraining, freigeschaltete Modelle, Tiere, Plätze und Geld geladen.

## Vorgesehener Spielkreislauf

Beim Fahren trainiert der Spieler Speed und holt Eier. Die Tiere daraus finanzieren den Gehegeausbau und Scooter-Upgrades. Beim Rebirth startet das Training von vorn und geht schneller. Bestimmte Rebirths geben einen besseren Kukurin für die nächsten Eier.

Valentin hat die zwei Komponenten bestätigt: Tiere liefern das Geld/s, Kukurin übernimmt den Speed-Fortschritt und ersetzt das Laufband. Genauer Schlüpfablauf, Einkommensabholung und Abschluss eines Diebstahls bleiben noch auszuarbeiten.

## Bestätigt: Fahren trainiert Speed

Die gefahrene Strecke bestimmt den Trainingsfortschritt. Für spätere Level innerhalb eines Durchgangs ist mehr Strecke nötig.

Mit einem höheren Rebirth-Stand füllt dieselbe Strecke die Trainingsleiste schneller. So erreicht der Spieler ein zuvor erspieltes Fahrlevel früher und kann danach auf den nächsten Meilenstein hinfahren.

Die genaue Trainingskurve und die Geschwindigkeit der Modelle werden im Spieltest abgestimmt. In den Stadtentwürfen fehlt die Trainingsleiste.

## Trainingsstadt und Wheelies

Die Hauptwelt hat die Tiergehege und den Eingang in den langen Gang zu den Tieren und Eiern. Die Trainingsstadt ist ein eigenes Ziel für Spieler, die einfach fahren wollen. Für den ersten Aufbau bieten sich breite Straßen mit Kreuzungen und einer durchgehenden Rundfahrt an. In beiden Welten gelten das ausgerüstete Kukurin-Modell, Fahrlevel, Trainingsleiste und Rebirth-Stand des Spielers. Der Weltwechsel selbst zählt keine Trainingsstrecke.

**Wheelie-Bonus.** Bei gleichem Rebirth-Stand soll eine gleich lange Fahrt mit Wheelie die Trainingsleiste weiter füllen als eine normale Fahrt. Gezählt wird nur der tatsächlich im Wheelie gefahrene Abschnitt. Beim Anhalten endet der Gewinn. Den Bonus verstehe ich als schnelleres Leveln. Die genaue Höhe und eine mögliche Nutzung in der Hauptwelt sind offen.

## Robux-Shop und Menüansichten

Der Robux-Shop erhält einen eigenen Zugang im HUD neben Kukurin-Übersicht und Tier-Index. Eine Angebotskarte zeigt den Artikel, seine Wirkung und den Preis in Robux. Spielgeld bleibt die Währung für Gehegeplätze und Verbesserungen am aktuellen Scooter. Neue Kukurin werden durch Rebirths freigeschaltet. Welche Artikel im Robux-Shop angeboten werden und was sie kosten, ist offen.

Als UI-Entwurf öffnet sich jeweils ein Menü mittig über der sichtbaren Spielwelt. Ein gut erreichbares X führt zur vorherigen Spielansicht. Bei Auswahl eines Angebots folgt die Roblox-Kaufbestätigung. Ein Abbruch kehrt zum Shop zurück. Die endgültigen Bildvorlagen entstehen nach Eingang von Valentins neuen Fotos.

## Scooter-Fortschritt

Geld und Rebirths haben beim Scooter zwei Aufgaben.

1. Verbesserungen am aktuellen Scooter kosten Spielgeld.
2. Ein neues Modell wird als kostenlose Belohnung direkt beim vorgesehenen Rebirth vergeben.

Offen sind Modellnamen, Modellfolge, Fahrwerte, Preise für Upgrades am aktuellen Scooter und die gewünschte Fahrzeit bis zum nächsten Rebirth.

## Vor Umsetzung zu konkretisieren

- Exakter Link zur gemeinten Steal-an-Egg-Erfahrung für spätere Live-Prüfung, falls nötig. Visuelle Originalreferenzen liegen bereits lokal vor und blockieren die Umsetzung nicht.
- Genaue Titelformulierung; **Kukurin** bleibt als Bestandteil festgelegt.
- Fahrgefühl: Steuerung, Beschleunigung, Bremsen, Kurven und Verhalten beim Tragen eines Eis.
- Diebstahlregeln, Einkommen je Tier, Eierwerte und mögliche Seltenheiten.
- Kartenabmessungen und Anordnung der Spielbereiche.
- Start-Scooter, Upgrade-Wirkung, Rebirth-Ziele und Preise für Gehegeplätze und Upgrades.

Diese offenen Punkte sind keine zusätzlich beschlossenen Features. Zahlen und Mechaniken werden erst bei ihrer Ausarbeitung festgelegt.
