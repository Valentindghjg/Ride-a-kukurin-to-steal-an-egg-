# Entwicklungsplan

## Leitlinie

Kurze Entwicklungszeit, kleine erste Version und einfache Logik. **Kukurin** muss im Spielnamen bleiben. Zuerst den vollständigen Kernablauf bauen; Inhalt und Feinschliff nur so weit ergänzen, wie für eine spielbare erste Version nötig. Kleine Detailfragen mit einfachen, dokumentierten Standardwerten lösen, statt die Entwicklung dafür anzuhalten.

## 1. Projektgrundlage

- [x] Spielidee und offene Entscheidungen festhalten.
- [x] Neun aktuelle Map- und UI-Ansichten von Valentin freigegeben. Stadt in Studio vereinfacht und blockig umsetzen.
- [x] Fahrtraining, Speed- und Levelreset beim Rebirth sowie schnelleres Leveln im neuen Durchgang festlegen.
- [ ] Startwerte, Trainingsfortschritt pro Strecke und Rebirth-Meilensteine konfigurieren.
- [x] Lokalen Studio-Startplatz anlegen und als `.rbxlx` im Repo versionieren.
- [ ] Startplatz als private Experience im Roblox-Konto speichern und ihre IDs hier zuordnen.

## 2. Erster spielbarer Ablauf

- [ ] Kleine Teststrecke und einen einfachen Scooter erstellen.
- [ ] Aufsteigen, Fahren, Lenken, Bremsen und Absteigen testen.
- [ ] Fahrstrecke serverseitig plausibilisieren, Speed-Training und kleine Trainingsleiste ergänzen. Stillstand/Teleports dürfen keinen Trainingsgewinn geben.
- [ ] Mit einem Test-Ei die Flucht aus einer hinteren Stage durch eine frühere Stage bis zur Safe Zone am Hof spielen. Der Wächter muss die Stagegrenze überqueren und die Verfolgung an der Safe Zone beenden.
- [ ] Einen Fang in einer fremden Stage testen. Der Wächter läuft danach bis zu seiner eigenen Stage zurück.
- [ ] Eier-/Tierablauf und Geld/s aus Tieren in der Basis implementieren.
- [ ] Ein Scooter-Upgrade und die automatische Freischaltung eines zweiten Modells bei einem Rebirth umsetzen.
- [ ] Ablauf mit mindestens zwei Spielern testen.

Der erste Prototyp ist fertig, wenn Spieler fahren, ein Ei stehlen, ein Tier Geld verdienen lassen und mit genug Fahrlevel einen Rebirth auslösen können.

## 3. Inhalt und Fortschritt ausbauen

Für die erste Veröffentlichung knapp halten: wenige Inhalte, funktionierende Speicherung und verlässliche Käufe. Größeren Inhaltsausbau und visuellen Feinschliff erst danach angehen.

- [ ] Erst breite, gut befahrbare Wege und die Einfahrten der Gehege bauen. Die Trainingsstadt mit wiederverwendbaren Straßen und wenigen Hausformen ausarbeiten.
- [ ] Basenhof mit Gehegen und klar erkennbarem Zugang zum langen Eiergang aufbauen. Separaten Wechsel in die große Trainingsstadt und Rückkehr zum Hof testen. Scooter, Fahrlevel und Trainingsfortschritt vor und nach dem Wechsel vergleichen.
- [ ] Normale Fahrt, Wheelie und Stillstand vergleichen. Bei gleicher Strecke und gleichem Rebirth-Stand muss der Wheelie mehr Training bringen. Wechsel zwischen Fahrzuständen darf dieselbe Strecke nur einmal zählen.
- [ ] Robux-Shop im HUD ergänzen. Öffnen, Schließen und Kaufabbruch prüfen. Für festgelegte Produkte bestätigte Käufe verarbeiten und die Belohnung pro Kauf genau einmal vergeben.
- [ ] Für jede veröffentlichte Stage ein eigenes Thema, fünf 3D-Eiermodelle, fünf sammelbare Tierarten und einen Wächter einbauen. Weiter hinten im Gang müssen Wächter schneller laufen.
- [ ] Beim selben Kukurin den Rückweg mit einem kleinen und einem größeren Ei vergleichen. Mit dem schwereren Ei fährt er langsamer. Das daraus geschlüpfte Tier wiegt mehr und verdient bei gleichem Einkommensbonus mehr Geld pro Sekunde.
- [ ] Weitere Scooter-Modelle ergänzen.
- [ ] Einen Rebirth mit Levelprüfung testen. Speed und Fahrlevel müssen auf die Startwerte fallen, die Tiere erhalten bleiben und der nächste Trainingslauf auf gleicher Strecke mehr Fortschritt bringen. Am Modell-Meilenstein den Kukurin genau einmal vergeben und den Kontostand durch die Modellvergabe nicht belasten.
- [ ] Kauf zusätzlicher Gehegeplätze und Geld/s bei unterschiedlicher Belegung prüfen.
- [ ] Preise und Einnahmen auf die gewünschte Progression abstimmen.
- [ ] Geld, Tiere, Gehegeplätze, Scooter-Besitz, Fahrtraining, Upgrades und Rebirth-Stand dauerhaft speichern.
- [ ] Käufe und Belohnungen serverseitig prüfen.
- [ ] Spielstand nach Verlassen und erneutem Beitreten prüfen.

## Speichern der Arbeit

Konzeptänderungen und Entwicklungsschritte werden hier dokumentiert. Skripte und benötigte Projektdateien werden im Repository versioniert. Reine Änderungen in Roblox Studio gelten erst dann als im Repository gesichert, wenn sie exportiert oder synchronisiert und committed wurden. Nach zusammenhängenden Arbeitsschritten wird der geprüfte Stand committed und zu GitHub gepusht; falls das nicht möglich ist, wird das ausdrücklich gemeldet.
