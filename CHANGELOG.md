# Projektstand

## 8. November 2026

Map als Code in [MapBuilder.luau](src/server/MapBuilder.luau) neu gebaut. Look aus den neun freigegebenen Bildern, Grundriss aus Valentins zwei Screenshots in [docs/design/grundriss](docs/design/grundriss/). Ummauerter Gehegehof mit Fahrspur, sieben Plot-Flächen in diagonaler Reihe (noch ohne Gehege), EIERGANG-Tor mit Safe-Zone-Grenze, fünf Stage-Zonen (Wald, Wüste, Eis, Vulkan, Kristall) und eine Trainingsstadt mit 4×4-Straßennetz, Park, Uhrturm und Portal „Zum Hof“. Der Weltwechsel über die Portale merkt sich den Zeitpunkt am Spieler, damit er später nicht als Fahrstrecke zählt. Offline ohne Laufzeitfehler geprüft (5.713 Teile). Valentin hat die Map in Studio angesehen und für gut befunden.

In der [Bauanleitung für Claude](CLAUDE.md#modellvorschlag-für-viele-stages) steht ein Vorschlag für wiederverwendbare 3D-Körper und erkennbare Eier- und Tiervarianten je Stage.

Rojo 7.7.1 für die Live-Synchronisierung von Server-, Client- und gemeinsamem Code eingerichtet.

Nach erneuter Anmeldung den Startplatz als private Roblox-Experience gespeichert. Studio hat das Speichern mit allen fünf Gerätekategorien bestätigt. Die IDs stehen in der [Projektübersicht](README.md).

Den lokalen Studio-Startplatz mit Grundplatte und Spawnpunkt angelegt und in Roblox Studio geöffnet. Beim ersten Speichern als neue Experience im Roblox-Konto hat Studio die Anmeldung mit HTTP 401 zurückgewiesen.

Valentin hat den [Eierdiebstahl im Stage-Gang](docs/SPIELKONZEPT.md#eier-stehlen-im-stage-gang) festgelegt. Jede thematische Stage enthält fünf Tierarten und fünf 3D-Eiermodelle. Schwere Eier bremsen den Kukurin stärker und bringen schwerere Tiere mit höherem Ertrag. Die Wächter späterer Stages laufen schneller. Sie verfolgen Spieler über Stagegrenzen hinweg bis zur Safe Zone am Hof. Nach einem Fang läuft der Wächter in seine Heimatstage zurück.

## 7. November 2026

Alle 20 offenen Fragen zu Preisen, Leveln, Spielregeln und Sonderfällen stehen im Ordner [offen](offen/README.md). Die Nummern bleiben für Antworten im Chat erhalten.

Valentin hat die neun aktuellen Map- und UI-Entwürfe freigegeben. Für die Umsetzung gilt ein einfacherer, weniger realistischer Roblox-Stil, besonders in der Trainingsstadt. Spielkonzept und Bauanleitung enthalten den abgestimmten Stand. Die nächsten Schritte sind im [Entwicklungsplan](docs/ENTWICKLUNGSPLAN.md) erfasst.
