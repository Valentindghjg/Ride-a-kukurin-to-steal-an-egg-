# Projektstand

## 8. November 2026

Fahrtraining eingebaut ([Training.luau](src/shared/Training.luau), [TrainingService](src/server/TrainingService.server.luau)). Der Server misst die tatsächlich gefahrene Strecke auf dem Kukurin. Stillstand, Portalsprünge, ein neuer Scooter und unplausible Sprünge zählen nicht, jede Messung ist auf das trainierte Tempo begrenzt. Fahren erhöht das trainierte Tempo stetig. Jedes Level beginnt bei einem festen Tempo, deshalb zeigt die Leiste „noch x km/h bis Level n+1“. Ein Levelaufstieg meldet sich als Hinweis.

Dokumentierte Startwerte für die offenen Fragen 08 und 09:
- Level 1 = 32 km/h, je Level +2 km/h.
- 900 Studs von Level 1 auf 2, danach je Level 30 % mehr. Überschüssige Strecke wird übertragen. Bis Level 10 sind es rund 29.000 Studs, etwa 14 Minuten Fahrt.
- Je Rebirth +50 % Trainingswirkung.
- Wheelie mit Leertaste, Gamepad A oder Handy-Taste: Er hebt das Vorderrad um 22° an. Der Server zählt den Abschnitt doppelt, sobald der Scooter wirklich mehr als 12° geneigt ist. Der Wheelie-Bonus in der UI leuchtet dann.
- Training startet auch in Studio echt bei Level 1. Nur Geld, Tiere und Eier haben dort noch Beispielwerte.

Oberfläche nach den Bildern 02 und 04–07 gebaut ([PC-Vorschau](docs/design/ui-vorschau-pc.jpg), [Handy-Vorschau](docs/design/ui-vorschau-handy.jpg)):
- Menüknöpfe links, Eier-Knopf rechts, Fahrinstrument unten links mit live km/h und Geld. Auf reinen Touch-Geräten wird das Instrument zur schmalen Leiste oben, damit der Joystick frei bleibt.
- Levelleiste nach Valentins Wunsch wie die Minecraft-Erfahrungsleiste: lang und schmal unten in der Mitte, mit Segmenten. Darüber links „Level n“, rechts „noch x km/h bis Level n+1“. Den Wert liefert später das Fahrtraining, in Studio steht ein Beispielwert.
- Robux-Shop mit Kaufbestätigung und Abbrechen, Tier-Index mit Silhouetten und Ertrag, Kukurin-Übersicht mit 3D-Vorschau, gesperrten Modellen und Rebirth-Leiste, „Meine Eier“ als Seitenleiste, Hinweise oben.
- Die Anzeigen lesen die Spielerdaten vom Server. In Roblox Studio setzt der Server Beispielwerte aus den Bildern, im Spiel gelten Startwerte (noch ohne Speicherung). Kaufen, Ausrüsten und Rebirth prüft der Server. Nicht eingerichtete Robux-Produkte und der noch fehlende Rebirth melden sich mit einem Hinweis, statt etwas zu vergeben.
- Inhalte (Tiere, Eier, Modelle, Shop-Artikel) stehen als Beispiele in [SpielKatalog.luau](src/shared/SpielKatalog.luau), bis die Fragen 10, 11, 15 und 19 entschieden sind.

Offline geprüft: Der UI-Code läuft in einer Roblox-Nachbildung fehlerfrei, die Szenen wurden für PC (1280×720) und Handy (844×390) gerendert. Valentin hat die UI bis auf die Levelanzeige abgenommen.

Seitliches Driften beim Fahren behoben, Valentin hat das Fahren danach in Studio bestätigt: Der Charakter ist während der Fahrt jetzt vollständig kraftlos (Lauftempo und Sprung 0, Bewegungssteuerung des Humanoids aus), damit sein kameraabhängiges Laufen den Scooter nicht seitwärts schiebt. Der Server hält die Physik-Hoheit beim Fahrer, kleine Stick-Ausschläge werden ignoriert. In Studio blendet F3 oben in der Mitte eine Diagnosezeile ein. Sie zeigt, wer die Physik steuert, Soll- und Ist-Tempo und das seitliche Rutschen.

Fahrbaren Kukurin gebaut. Das Modell folgt Valentins Fotovorlage eines schwarzen E-Scooters: rundes Lenkrohr mit Klappgelenk und rotem Riegel, T-Lenker mit Display, Klingel und rundem Scheinwerfer, langes flaches Trittbrett mit abgerundeten Ecken und „Kukurin“-Schriftzug, gebogene Schutzbleche, Räder mit gerundeter Reifenflanke und Speichen, Scheibenbremse hinten und Rücklicht. Dazu kommen orange Akzente aus den Design-Bildern ([Vorschau](docs/design/kukurin-modell-vorschau.png)). Nach Valentins Fahrtest wurde nur die Optik überarbeitet, die Fahrphysik blieb gleich. Jeder Spieler bekommt beim Spawnen seinen eigenen Kukurin neben den Spawnpunkt. Aufsteigen mit E oder Antippen, Fahren mit WASD oder Joystick, Absteigen mit F oder der Handy-Taste. Lenker und Räder bewegen sich mit, der Fahrer hält den Lenker. Die Portale nehmen den Scooter samt Fahrer mit. Startwerte für Tempo, Beschleunigung und Lenkung stehen in [KukurinConfig.luau](src/shared/KukurinConfig.luau) (offene Frage 07). Offline geprüft: Alle 88 Teile hängen am Fahrgestell, nur die zwei Kontaktkugeln kollidieren. Valentin hat das Fahren in Studio getestet und für gut befunden.

Map als Code in [MapBuilder.luau](src/server/MapBuilder.luau) neu gebaut. Look aus den neun freigegebenen Bildern, Grundriss aus Valentins zwei Screenshots in [docs/design/grundriss](docs/design/grundriss/). Ummauerter Gehegehof mit Fahrspur, sieben Plot-Flächen in diagonaler Reihe (noch ohne Gehege), EIERGANG-Tor mit Safe-Zone-Grenze, fünf Stage-Zonen (Wald, Wüste, Eis, Vulkan, Kristall) und eine Trainingsstadt mit 4×4-Straßennetz, Park, Uhrturm und Portal „Zum Hof“. Der Weltwechsel über die Portale merkt sich den Zeitpunkt am Spieler, damit er später nicht als Fahrstrecke zählt. Offline ohne Laufzeitfehler geprüft (5.713 Teile). Valentin hat die Map in Studio angesehen und für gut befunden.

In der [Bauanleitung für Claude](CLAUDE.md#modellvorschlag-für-viele-stages) steht ein Vorschlag für wiederverwendbare 3D-Körper und erkennbare Eier- und Tiervarianten je Stage.

Rojo 7.7.1 für die Live-Synchronisierung von Server-, Client- und gemeinsamem Code eingerichtet.

Nach erneuter Anmeldung den Startplatz als private Roblox-Experience gespeichert. Studio hat das Speichern mit allen fünf Gerätekategorien bestätigt. Die IDs stehen in der [Projektübersicht](README.md).

Den lokalen Studio-Startplatz mit Grundplatte und Spawnpunkt angelegt und in Roblox Studio geöffnet. Beim ersten Speichern als neue Experience im Roblox-Konto hat Studio die Anmeldung mit HTTP 401 zurückgewiesen.

Valentin hat den [Eierdiebstahl im Stage-Gang](docs/SPIELKONZEPT.md#eier-stehlen-im-stage-gang) festgelegt. Jede thematische Stage enthält fünf Tierarten und fünf 3D-Eiermodelle. Schwere Eier bremsen den Kukurin stärker und bringen schwerere Tiere mit höherem Ertrag. Die Wächter späterer Stages laufen schneller. Sie verfolgen Spieler über Stagegrenzen hinweg bis zur Safe Zone am Hof. Nach einem Fang läuft der Wächter in seine Heimatstage zurück.

## 7. November 2026

Alle 20 offenen Fragen zu Preisen, Leveln, Spielregeln und Sonderfällen stehen im Ordner [offen](offen/README.md). Die Nummern bleiben für Antworten im Chat erhalten.

Valentin hat die neun aktuellen Map- und UI-Entwürfe freigegeben. Für die Umsetzung gilt ein einfacherer, weniger realistischer Roblox-Stil, besonders in der Trainingsstadt. Spielkonzept und Bauanleitung enthalten den abgestimmten Stand. Die nächsten Schritte sind im [Entwicklungsplan](docs/ENTWICKLUNGSPLAN.md) erfasst.
