# Projektstand

## 8. November 2026

Werkstatt mit Motor-Upgrade ([UpgradeService](src/server/UpgradeService.server.luau)): Wie in Bild 02 steht neben dem Weg zur Trainingsstadt eine Werkstatt mit Petrol-Dach, Werkzeugwand, Werkbank und rotem Schrank. An der Werkbank verbessert man den Motor mit Spielgeld: 5 Stufen, je +1,5 km/h, Preise $300, $600, $1.200, $2.400 und $4.800. Das Upgrade gilt für alle Modelle, bleibt beim Rebirth erhalten und wird gespeichert (Startwerte für Frage 10). Offline durchgespielt: zu wenig Geld, Ausbau bis Stufe 5, kein Kauf über das Maximum, Erhalt beim Rebirth.

Spielstand speichern und laden ([DataService](src/server/DataService.server.luau), [SaveData](src/server/SaveData.luau)):
- Gesichert werden Geld, Level mit Trainingsleiste, Rebirths, ausgerüstetes Modell, Tier-Index, Eier und das Gehege mit Plätzen und Tieren.
- Gespeichert wird beim Verlassen, alle 60 s und beim Herunterfahren des Servers.
- Schlägt das Laden fehl, speichert der Server für diesen Spieler nicht, damit ein vorhandener Stand nie mit Startwerten überschrieben wird.
- Geladene Werte werden geprüft und begrenzt. Unbekannte Eier und Tiere fallen weg, und gesperrte Modelle werden nicht ausgerüstet.
- Roblox Studio nutzt einen eigenen Speicher. Dafür muss unter Game Settings > Security „Enable Studio Access to API Services“ eingeschaltet sein, sonst erscheint ein Hinweis.
- Offline durchgespielt: neuer Spieler, Speichern beim Verlassen, Wiederbeitritt mit allen Werten, bereinigter beschädigter Stand, Ladefehler ohne Überschreiben, Sichern beim Herunterfahren.

Rebirth eingebaut ([RebirthService](src/server/RebirthService.server.luau)):
- Rebirth 1 ab Level 10 (Valentins Beispiel), jeder weitere 5 Level später.
- Der Rebirth setzt Level, Trainingsleiste und Tempo auf den Start zurück. Tiere, Geld, Eier und Gehegeplätze bleiben (Startwert für Frage 16).
- Belohnung je Rebirth: +50 % Training und +5 % Tiereinkommen.
- Beim Meilenstein gibt es das Modell genau einmal kostenlos und sofort ausgerüstet: Rebirth 2 bringt den petrolfarbenen City-Kukurin mit +4 km/h. Wechselt das ausgerüstete Modell, tauscht der Server den Scooter an Ort und Stelle aus, während der Fahrt erst nach dem Absteigen.
- In der Kukurin-Übersicht zeigt die Rebirth-Leiste die nächste Nummer und das nötige Level. Vor dem Auslösen erscheint eine Bestätigung mit Reset und Belohnung. Freigeschaltete Modelle erscheinen in ihrer echten Farbe.
- Höchsttempo = trainiertes Tempo + Modellbonus, zentral in [PlayerStats](src/server/PlayerStats.luau).
- Offline durchgespielt: zu niedriges Level, Rebirth 1 mit Reset, Voraussetzung für Rebirth 2, City-Vergabe bei Rebirth 2, keine Doppelvergabe bei Rebirth 3, Tempo nach Modellwechsel.

Gehege mit Tieren und Einkommen eingebaut ([GehegeService](src/server/GehegeService.server.luau)):
- Jeder Spieler bekommt beim Beitritt eines der sieben Plots. Am Eingang steht das Gehegeschild wie in Bild 08 mit Besitzer, Belegung und Preis für den nächsten Platz, dort kauft man per Taste Plätze mit Spielgeld.
- Startwerte: 3 Plätze, höchstens 8, der 4. Platz kostet $250, jeder weitere das 2,5-fache.
- Ein Ei in „Meine Eier“ antippen brütet es aus. Das Tier schlüpft sofort, steht als blockige Figur in den Farben seiner Stage auf dem nächsten freien Platz und erscheint im Tier-Index. Ist das Gehege voll, bleibt das Ei liegen und ein Hinweis erscheint.
- Einkommen jede Sekunde automatisch, auch in der Trainingsstadt. Je Rebirth gibt es +5 % (Valentins Beispiel), offline verdient man nichts. Das HUD zeigt „+x/s“ neben dem Geld.
- Den Stand speichert der Dienst als Spielerangabe „Gehege“. Ein geladener Spielstand baut das Gehege daraus neu auf.
- Offline durchgespielt: Zuteilung, Ausbrüten bis zum vollen Gehege, Einkommen (+100 in 10 s bei 10 $/s), Platzkauf, Rebirth-Bonus, zweiter Spieler, geladener Spielstand, Freigabe beim Verlassen.

Eier stehlen mit Wächtern eingebaut ([EggService](src/server/EggService.server.luau), [SpielKatalog](src/shared/SpielKatalog.luau)):
- Jede Stage hat fünf Eiergrößen von „klein“ bis „gigantisch“ und fünf Tiere. Wald: Maus, Hase, Fuchs, Reh, Bär. Wüste: Skorpion, Echse, Schlange, Kamel, Löwe. Eis: Pinguin, Robbe, Eule, Wolf, Mammut. Vulkan: Käfer, Fledermaus, Krabbe, Nashorn, T-Rex. Kristall: Schmetterling, Pfau, Flamingo, Einhorn, Drache.
- Größere Eier sind seltener (40/28/18/10/4 %) und bremsen den Kukurin stärker (Tempo ×0,92 bis ×0,6). Daraus schlüpfen Tiere mit mehr Geld pro Sekunde: im Wald 2 bis 16 $/s, jede Stage weiter hinten ×4. Große Eier leuchten.
- Die Eier liegen für alle Spieler gemeinsam aus, sechs Plätze je Stage. Ein abgegebenes Ei wird nach 15 s ersetzt. Man trägt höchstens ein Ei, gut sichtbar auf dem Rücken. Mit Ei gibt es keinen Wheelie.
- Jede Stage hat einen blockigen Wächter in ihrer Farbe (22 km/h in Stage 1, je Stage +4). Er jagt den nächsten Dieb mit einem Ei aus seiner Stage durch die Durchgänge auch in andere Stages. Am EIERGANG-Tor (Safe Zone) endet die Jagd.
- Fängt er dich, kehrt das Ei an seinen Platz zurück, dir passiert sonst nichts, und der Wächter läuft heim. Erreichst du den Hof, landet das Ei unter „Meine Eier“.
- Verlässt man das Spiel oder stirbt, kehrt das Ei zurück.
- Offline durchgespielt: Flucht aus Stage 3 durch Stage 2 und 1 bis in den Hof (der Wächter überquert die Stagegrenze, ohne durch Mauern zu laufen, und kehrt danach heim) sowie ein Fang bei zu langsamer Flucht.

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
