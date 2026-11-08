# Offene Entscheidungen für Ride a Kukurin to Steal an Egg

Die 20 Fragen haben feste Nummern für Antworten im Chat. Die vereinbarten Spielregeln stehen im [Spielkonzept](../docs/SPIELKONZEPT.md), die neun freigegebenen Ansichten in der [Bildgalerie](../docs/design/README.md).

## Die Angaben in den Bildern richtig lesen

| Vorhandenes Beispiel | Was tatsächlich offen ist |
| --- | --- |
| Erster Rebirth ab Level 10. Rebirth 2 gibt einen Kukurin und +5 % Tiereinkommen. | Das ist Valentins Rechenbeispiel. Endgültige Levelziele, Modellbelohnungen und Einkommensboni je Rebirth fehlen. Der Bonus auf Fahrtraining braucht einen eigenen Wert. |
| 32 km/h, Level 6 und $1.250 im Fahr-HUD | Ein Beispiel-Spielstand. Daraus folgen weder Startwerte noch Speed pro Level oder die Umrechnung in Roblox-Strecke. |
| „Starter“ und „City“ in der Modellübersicht | Beispielnamen und Beispielmodelle. Neue Modelle werden beim zugehörigen Rebirth kostenlos vergeben. Zu klären sind Modellliste und Freischaltfolge. |
| „Wald-Ei“, „Stadt-Ei“, Katze mit +8 $/s und 3 von 6 Tieren entdeckt | Beispiele für Darstellung und Platzbedarf. Eierliste, Tierliste, Chancen und Einkommen müssen festgelegt werden. |
| 3 von 3 Plätzen, +1 Platz für $2.500 bei $3.250 Guthaben | Ein möglicher Kaufzustand. Startplätze, Höchstkapazität und sämtliche Ausbaupreise sind offen. |
| Neon-Griffe für 49 Robux und Sternendeck für 79 Robux | Beispielangebote. Sortiment, Preise, Wirkung und Besitzregeln sind offen. |

## Ablauf, Welt und Risiko

| Nr. | Thema | Zu entscheiden |
| --- | --- | --- |
| 01 | Erste Spielminute und Umfang | Mit welchem Fahrlevel, Speed, Geld, Gehege und Bestand an Eiern oder Tieren startet ein neuer Spieler? Der einfache Start-Kukurin steht fest. Wie entdeckt der Spieler sein Gehege, das erste Ei und die Rückgabe? Wie viele Stages, Kukurin-Modelle und Rebirths erscheinen zum Start? Aus der Stageanzahl ergibt sich der Modellbedarf mit je fünf Tierarten und fünf Eiermodellen pro Stage. |
| 02 | Hauptwelt und Zonen | Wie viele Spieler und Gehege passen in einen Server? Wie wird ein freies Grundstück zugeteilt, und was passiert bei vollem Hof? Welche Themen, Reihenfolge und Abmessungen bekommen die Stages? Wo liegen Eier und Abgabepunkt? Gibt es Zugangsvoraussetzungen? Die Safe Zone beginnt am Übergang vom Gang zum Gehegehof. |
| 03 | Tempo bei der Flucht | Schwerere Eier bremsen den Kukurin stärker und spätere Stages haben schnellere Wächter. Wie stark sinkt das Fahrtempo je Eigewicht und wie schnell läuft jeder Wächter? Mit welchem Kukurin und Trainingsstand soll ein Spieler das schwerste Ei einer Stage heimbringen können? |
| 04 | Diebstahl und Flucht | In jeder Stage bewacht ein Tier die Eier und verfolgt den Spieler auch durch fremde Stages bis zur Safe Zone. Nach einem Fang läuft es in seine eigene Stage zurück. Was löst die Jagd aus, wie wählt der Wächter bei mehreren Spielern sein Ziel und wie verhält er sich nach einer erfolgreichen Flucht? Was passiert mit Spieler und Ei bei einem Fang? Wie hebt man Eier auf, wie viele kann man tragen und wann wird ein gerettetes Ei gutgeschrieben? Können Spieler auch aus fremden Gehegen stehlen? |
| 05 | Gemeinsame Eier und Sonderfälle | Sind Eier für den gesamten Server oder je Spieler sichtbar? Wie viele liegen je Zone, wie werden sie verteilt und wann erscheinen sie erneut? Was geschieht bei zwei gleichzeitigen Zugriffen? Wohin geht ein getragenes Ei bei Abstieg, Sturz, Reset, Rebirth, Weltwechsel, Verbindungsabbruch oder Verlassen des Spiels? |
| 06 | Trainingsstadt | Größe, Fahrtzeit für eine Runde, Zahl der tatsächlich befahrbaren Straßenzüge und Lage der Ein- und Ausgänge. Wie wird der Wechsel ausgelöst, wo landet man bei der Rückkehr und darf man mit Beute wechseln? Trainiert eine normale Strecke in beiden Welten gleich schnell? Der gemeinsame Fortschritt, die freie Fahrt und die einfache blockige Gestaltung stehen fest. |

## Fahrtraining und Kukurin

| Nr. | Thema | Zu entscheiden |
| --- | --- | --- |
| 07 | Fahrgefühl | Aufsteigen, Rufen und Wiederfinden des Scooters, Absteigen, Gas, Bremse, Rückwärtsfahrt und Lenken auf Handy und PC. Werte für Starttempo, Beschleunigung, Bremsweg und Wendekreis. Wie funktionieren Kollisionen, Umkippen, Wiederaufsetzen und das Fahren mit Ei? Was zeigt das HUD als km/h und wie entspricht das der Strecke im Spiel? |
| 08 | Trainingskurve | Welche Fahrstrecke füllt die erste Stufe? Wie wächst der Bedarf je Level? Wie viel Speed bringt ein Level? Gibt es Level- oder Tempogrenzen? Wie wird überschüssige Strecke beim Stufenwechsel verrechnet? Zählen Rückwärtsfahrt, Rollen, Sprünge und Kreisfahrten wie normale Fahrt? Für Stillstand und den Weltwechsel selbst ist bereits festgelegt, dass sie keinen Trainingsfortschritt geben. |
| 09 | Wheelie | Welche Taste oder Touch-Aktion startet und beendet ihn? Ab welcher Bewegung zählt er, wie lange kann man ihn halten, was beendet ihn und gibt es eine Erholungszeit? Wie viel mehr Training gibt dieselbe Strecke? Gilt er auch im Eiergang, insbesondere mit Beute? Wie wird sein Bonus mit schnellerem Leveln nach Rebirth verrechnet? Wenn ein Wheelie dauerhaft möglich ist, welchen Vorteil hat normale Fahrt? |
| 10 | Modelle | Wie viele Modelle gibt es, wie heißen sie, bei welchem Rebirth kommt welches gratis und woran unterscheiden sie sich beim Fahren? Kann man ältere Modelle wieder ausrüsten? Wie wirken Modellbonus und trainierter Speed zusammen? Festgelegt: Bessere Roller gibt es nur über den Rebirth, nicht über Spielgeld-Upgrades. |

## Eier, Gehege und Geld

| Nr. | Thema | Zu entscheiden |
| --- | --- | --- |
| 11 | Eier- und Tierkatalog | Je Stage stehen fünf 3D-Eiermodelle und fünf sammelbare Tierarten fest. Welche sind es, wie groß und schwer sind die Eier und wie häufig erscheinen sie? Welche Tierart schlüpft aus welchem Ei, wie viel wiegt sie und wie viel Geld/s verdient sie? Die Reihenfolge ist vorgegeben: schwereres Ei, schwereres Tier, höherer Ertrag. Ist der Wächter eines der fünf Tiere oder bekommt er ein eigenes Modell? |
| 12 | Vom Ei zum Tier | Was passiert nach sicherer Rückkehr? Schlüpft das Tier sofort, nach Wartezeit oder nach einer Aktion? Wo liegen Eier bis dahin, wie viele passen hinein, wie viele können parallel schlüpfen und läuft Zeit beim Verlassen weiter? Wird ein neues Tier automatisch eingesetzt oder wählt der Spieler es aus? Was passiert mit Duplikaten? Wann zählt ein Tier als entdeckt und bleibt der Indexeintrag erhalten? |
| 13 | Gehegeplätze | Wie viele Plätze sind anfangs frei, wie viele bringt jede Stufe, was kostet sie und wo liegt die Grenze? Erweitert sich auch die sichtbare Fläche? Was passiert bei vollem Gehege mit dem nächsten Ei oder geschlüpften Tier? Kann man Tiere lagern, herausnehmen oder austauschen und was tun, wenn kein Platz frei ist? Der Kauf eines leeren Platzes erhöht das Einkommen erst nach dem Einsetzen eines Tiers. |
| 14 | Auszahlen und Wirtschaft | Wann beginnt und endet der Verdienst eines eingesetzten Tiers? Wird Geld automatisch gutgeschrieben oder am Gehege abgeholt? Verdient es während der Fahrt in der Trainingsstadt weiter? Gibt es Offline-Einkommen, und falls ja, für welche Höchstdauer und zu welchem Satz? Wie wird gerundet, wenn Boni Bruchteile ergeben? Stimmen Tiererträge und Platzpreise so zusammen, dass die nächsten Ziele erreichbar sind? |

## Rebirths und Spieldauer

| Nr. | Thema | Zu entscheiden |
| --- | --- | --- |
| 15 | Rebirth-Tabelle | Welches Fahrlevel braucht jeder Rebirth? Wie viele Rebirths sind zum Start erreichbar, was ist beim letzten das nächste Ziel? Pro Rebirth werden drei Einträge gebraucht: Bonus auf Fahrtraining, eventueller Bonus auf Tiereinkommen und eventuelle Modellfreischaltung. Addieren oder multiplizieren sich wiederholte Boni? |
| 16 | Reset und Besitz | Speed und Fahrlevel starten von vorn, die Leiste leert sich, Tiere bleiben. Welcher Start-Speed gilt nach einem Rebirth mit besserem Modell? Was passiert mit Spielgeld, unbezahltem Tierertrag, Gehegeplätzen, Eiern und laufenden Schlüpfvorgängen? Falls Plätze zurückgesetzt werden, wo bleiben die behaltenen Tiere und welche verdienen weiter? Wo beginnt die nächste Runde, welches Modell wird ausgerüstet und wann darf man Rebirth auslösen? |
| 17 | Gewünschtes Spieltempo | Wie viele Minuten bis zum ersten Level, zum ersten Ei, zur ersten Auszahlung und zum ersten Platzkauf? Wie lange bis zu Rebirth 1, zum nächsten Kukurin und schließlich zum besten Modell? Welche dieser Ziele soll man in der ersten Sitzung schaffen? Wie ändern sich die Zeiten bei normaler Fahrt, vielen Wheelies und nach Rebirth? Wie lange dauert ein Ausflug pro Zone hin und zurück? |

## Bedienung, Shop und offene Arbeit

| Nr. | Thema | Zu entscheiden oder umzusetzen |
| --- | --- | --- |
| 18 | Anzeigen und Bedienabläufe | Wo werden Eier abgegeben, Tiere eingesetzt oder gewechselt und Rebirths ausgelöst? Welche Aktion erfordert eine Bestätigung? Welche Rückmeldung erscheint bei vollem Gehege, zu wenig Geld, Fang, Levelaufstieg, gesperrtem Modell und Weltwechsel? Was geschieht beim Öffnen eines Menüs während der Fahrt? Genaue Tasten, Touch-Flächen, Kameraführung und Anpassung für kleine Displays sind offen. Das Layout der neun Bilder ist freigegeben. |
| 19 | Robux-Angebote | Welche Artikel kommen zum Start tatsächlich in den Shop? Je Artikel fehlen Preis, Wirkung, einmaliger oder wiederholbarer Kauf, Dauer und gegebenenfalls Ausrüsten oder Stapeln. Was behält der Spieler nach Rebirth und Wiederbeitritt? Ein Kaufabbruch vergibt nichts. Auf eine bestätigte Zahlung erhält der Spieler den Artikel genau einmal. Produktzuordnung und Kaufprüfung im Spiel stehen aus. |
| 20 | Umsetzung und Prüfung | Der lokale Studio-Startplatz liegt im Repo und ist als private Experience im Roblox-Konto gespeichert. Ein fahrbarer Prototyp und Spieltests stehen aus. Wie werden Hof und Trainingsstadt technisch verbunden? Festzulegen sind Speicherzeitpunkte, Wiederherstellung nach Abbruch und der Umgang mit gleichzeitigem Kauf, Eierzugriff oder Wiederbeitritt. Fahrtraining, Einkommen, Besitz, Käufe und Rebirth serverseitig prüfen. Zum Testumfang siehe [Entwicklungsplan](../docs/ENTWICKLUNGSPLAN.md). |

## Welche Tabellen danach gebraucht werden

1. **Fahrlevel** mit Strecke bis zur nächsten Stufe, Speed-Gewinn und erwarteten Fahrminuten.
2. **Kukurin-Modelle** mit Rebirth-Voraussetzung und Fahrwerten.
3. **Stages, Eier und Tiere** mit Thema, Hin- und Rückstrecke, Wächter und Verfolgungstempo. Je Stage fünf Eiermodelle und fünf Tierarten erfassen, einschließlich Eigewicht, Fahrtempo mit Beute, Nachschub, Schlüpfergebnis, Tiergewicht und Geld/s.
4. **Gehege** mit Stufe, Gesamtplätzen, zusätzlichen Plätzen und Preis.
5. **Rebirths** mit erforderlichem Level, Reset-Regeln, Trainingsbonus, Einkommensbonus und Modellbelohnung.
6. **Robux-Artikel** mit Produktart, Preis, Wirkung, Dauer und Besitzregeln.

Für eine erste Gesprächsrunde lassen sich die Regeln zu Diebstahl und Gefahr (03–05), vollem Gehege (13), Rebirth-Reset (16) und gewünschter Spieldauer (17) unabhängig von finalen Preisen entscheiden.
