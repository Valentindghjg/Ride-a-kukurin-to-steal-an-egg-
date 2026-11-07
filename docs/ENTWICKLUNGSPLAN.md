# Entwicklungsplan

## Leitlinie

Kurze Entwicklungszeit, kleine erste Version und einfache Logik. **Kukurin** muss im Spielnamen bleiben. Zuerst den vollständigen Kernablauf bauen; Inhalt und Feinschliff nur so weit ergänzen, wie für eine spielbare erste Version nötig. Kleine Detailfragen mit einfachen, dokumentierten Standardwerten lösen, statt die Entwicklung dafür anzuhalten. Die konkrete Steal-an-Egg-Referenz ist für deren genaue Nachbildung erforderlich, blockiert aber keinen einfachen Kernprototyp.

## 1. Projektgrundlage

- [x] Repository finden und lokal klonen.
- [x] Spielidee und offene Entscheidungen festhalten.
- [x] Acht Originalansichten aus Steal-a-Crystal erfassen, visuell prüfen und für Claude beschreiben.
- [x] Aktives Fahren als Trainingsfaktor bestätigen; Speed-Stufen beim Modellwechsel behalten.
- [ ] Einfache Formel für Fahrtraining, Modellgrenzen und Geld-Upgrades konfigurieren.
- [ ] Roblox-Studio-Projekt zuordnen und Speicher-/Synchronisierungsweg einrichten.

## 2. Erster spielbarer Ablauf

- [ ] Kleine Teststrecke und einen einfachen Scooter erstellen.
- [ ] Aufsteigen, Fahren, Lenken, Bremsen und Absteigen testen.
- [ ] Fahrstrecke serverseitig plausibilisieren, Speed-Training und kleine Trainingsleiste ergänzen. Stillstand/Teleports dürfen keinen Trainingsgewinn geben.
- [ ] Ein Test-Ei mit einem vollständigen Diebstahlablauf ergänzen.
- [ ] Eier-/Tierablauf und Geld/s aus Tieren in der Basis implementieren.
- [ ] Ein Scooter-Upgrade und den Kauf eines zweiten Modells umsetzen.
- [ ] Ablauf mit mindestens zwei Spielern testen.

Der erste Prototyp ist fertig, wenn Spieler fahren, ein Ei stehlen, damit Geld verdienen und dieses Geld für Scooter-Fortschritt verwenden können.

## 3. Inhalt und Fortschritt ausbauen

Für die erste Veröffentlichung knapp halten: wenige Inhalte, funktionierende Speicherung und verlässliche Käufe. Größeren Inhaltsausbau und visuellen Feinschliff erst danach angehen.

- [ ] Map anhand der abgestimmten Referenz ausarbeiten.
- [ ] Eier und weitere Scooter-Modelle ergänzen.
- [ ] Einen Rebirth mit Levelprüfung und Erhalt aller Tiere testen. Die Meilensteinbelohnung genau einmal vergeben. Reset-Regeln und endgültige Schwellen abstimmen.
- [ ] Kauf zusätzlicher Gehegeplätze und Geld/s bei unterschiedlicher Belegung prüfen.
- [ ] Preise und Einnahmen auf die gewünschte Progression abstimmen.
- [ ] Geld, Tiere, Gehegeplätze, Scooter-Besitz, Fahrtraining, Upgrades und Rebirth-Stand dauerhaft speichern.
- [ ] Käufe und Belohnungen serverseitig prüfen.
- [ ] Spielstand nach Verlassen und erneutem Beitreten prüfen.

## Speichern der Arbeit

Konzeptänderungen und Entwicklungsschritte werden hier dokumentiert. Skripte und benötigte Projektdateien werden im Repository versioniert. Reine Änderungen in Roblox Studio gelten erst dann als im Repository gesichert, wenn sie exportiert oder synchronisiert und committed wurden. Nach zusammenhängenden Arbeitsschritten wird der geprüfte Stand committed und zu GitHub gepusht; falls das nicht möglich ist, wird das ausdrücklich gemeldet.
