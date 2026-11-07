# Bildaufträge – Kukurin-Stadt, Version 1

Erzeugt mit dem integrierten Imagegen-Werkzeug (kein CLI/API-Fallback). Acht getrennte Bearbeitungen der acht Originalansichten; keine Kristallspiel-Entwürfe als Input. Originale unverändert erhalten. Bild 01 wurde zuerst erstellt und bei Bildern 02–09 zusätzlich als Stilreferenz verwendet.

Die Aufträge wurden vor der Bestätigung des Fahrtrainings gestartet. Die Dokumentation ergänzt diese spätere Entscheidung; die Bilder enthalten noch keine Trainingsleiste.

## Gemeinsamer Auftrag (wörtlich)

```text
Use case: style-transfer. Edit target: image 1, an original Steal an Egg Roblox screenshot. Create ONE full landscape screenshot mockup for our game "Ride a Kukurin to Steal an Egg". Keep the original camera, perspective, blocky Roblox 3D geometry, relative building/plot/route layout and UI placement. Reskin into a cheerful simple Roblox CITY: gray asphalt roads with white lane markings, pale sidewalks, modest colorful blocky low-rise buildings, streetlights, small planted green areas. Keep fenced player plots in their original positions, as urban egg/pet courtyards with yellow or brown low fences, still containing eggs and pets. Keep the long straight progression corridor where shown; city blocks and street sections replace biomes without changing its footprint. Do NOT make a realistic city or an elaborate new map. Black electric standing scooters with orange accents, branded text "Kukurin", identifiable deck, two wheels, stem and handlebars. Replace shoe speed HUD with scooter icon and yellow scooter speed, green cash below. Use sample values "40 km/h" and "$1,250" consistently, never the huge original numbers. Preserve left green shop / cyan index buttons, right red egg / orange paw icons, thick black outlines, bold white playful UI text, bright Roblox studded textures where suitable. Remove desktop window chrome, chat notification details, original usernames and seasonal countdown mascot. Text must be legible German. Retain eggs/pets as the collectible theme, no crystals, mines, moles, digging or tools. This is a visual implementation reference for Claude Code, not marketing art. Each image must be internally coherent.
```

## 01-map-overview-city-v1.png

Bearbeitungsziel: `references/steal-an-egg/screenshots/01-map-overview.png`.

```text
High oblique map overview: preserve exact arrangement of rectangular fenced player plots and central shared aisle. Turn the aisle into a small street, sidewalks beside plots, low-rise city buildings along original perimeter walls. Scooter shop stand near original stalls, marked 'KUKURIN'. Add a few parked black/orange scooters and a rider without obscuring layout. Preserve open egg/pet plots and house ownership markers. No central modal. Left buttons 'Kukurin' and 'Index'.
```

## 02-collection-index-city-v1.png

Bearbeitungsziel: `references/steal-an-egg/screenshots/02-collection-index.png`.
Zusätzliche Stilreferenz: `01-map-overview-city-v1.png`. Bild 1 ist das Bearbeitungsziel, Bild 2 dient ausschließlich als Stadt-/Scooter-/HUD-Stilreferenz, nicht für Kamerawinkel oder Menülayout.

```text
Preserve the original centered 'Haustier-Index' modal layout: cyan title strip, red X, forest category card, two-row pet card grid with discovered pets and unknown silhouettes, right preview and reward panel, bottom collection progress. Keep egg/pet collection rather than scooter collection. Replace shoe reward with a small cash reward only; no personal speed or scooter reward invented. Background is the same urban plot map, blurred. Text 'Haustier-Index', 'Wald', 'Welt', 'Begrenzt', 'Freigeschaltet: 5/8', 'Belohnung', '$100', 'Einsammeln'.
```

## 03-kukurin-shop-city-v1.png

Bearbeitungsziel: `references/steal-an-egg/screenshots/03-premium-shop.png`.
Zusätzliche Stilreferenz: `01-map-overview-city-v1.png`. Bild 1 ist das Bearbeitungsziel, Bild 2 dient ausschließlich als Stadt-/Scooter-/HUD-Stilreferenz, nicht für Kamerawinkel oder Menülayout.

```text
Adapt the original large central green-title shop window into our cash-based scooter shop. Keep modal outer bounds and right-side vertical category rail. Title 'Kukurin-Geschäft', categories 'Modelle', 'Upgrades'. Replace Halloween event banner, odds, Robux prices and gift buttons with THREE clear black/orange electric scooter product cards. Names 'Kukurin Starter', 'Kukurin City', 'Kukurin Pro'. Card speeds 25, 40, 60 km/h respectively. Starter state 'Ausgerüstet'; City '$2,500' with 'Kaufen'; Pro '$15,000' with 'Kaufen'. Mark prices as illustrative UI examples by a small footer 'Beispielwerte'. Maintain chunky Roblox green buttons, black outlines, white text, red X, dark content background. Same blurred city courtyard behind. Do not reproduce monetized random egg shop.
```

## 04-egg-side-panel-city-v1.png

Bearbeitungsziel: `references/steal-an-egg/screenshots/04-egg-side-panel.png`.
Zusätzliche Stilreferenz: `01-map-overview-city-v1.png`. Bild 1 ist das Bearbeitungsziel, Bild 2 dient ausschließlich als Stadt-/Scooter-/HUD-Stilreferenz, nicht für Kamerawinkel oder Menülayout.

```text
Keep the original oblique map camera and exact right side panel bounds, brown/beige header, dark empty content body and red collapse arrow on its left edge. Title 'Wachsende Eier', yellow header action 'Alle anbauen'. These are reference labels, not a new system redesign. City street, plot courtyards, urban perimeter as in image 1. Scooters at street edge. No extra modal, do not fill empty panel with invented mechanics.
```

## 05-map-progression-city-v1.png

Bearbeitungsziel: `references/steal-an-egg/screenshots/05-map-progression.png`.
Zusätzliche Stilreferenz: `01-map-overview-city-v1.png`. Bild 1 ist das Bearbeitungsziel, Bild 2 dient ausschließlich als Stadt-/Scooter-/HUD-Stilreferenz, nicht für Kamerawinkel oder Menülayout.

```text
Preserve original high frontal overview with fenced base plots in foreground and a single long straight progression corridor receding centrally to horizon. Reskin base hub as city courtyard with asphalt central crossing and sidewalks, keep player plots and eggs/pets. Reskin successive corridor sections as distinct colored city street districts, low-rise facades on both sides following original high retaining wall footprint; foreground residential, farther commercial and neon accents. Keep route straight, unobstructed and legible, same width relative to base hub, no branching labyrinth, no aerial skyline shot. Replace original ground safe line with 'SICHERE ZONE'. Show one Kukurin rider entering street. No modal.
```

## 06-kukurin-upgrades-city-v1.png

Bearbeitungsziel: `references/steal-an-egg/screenshots/06-trail-shop.png`.
Zusätzliche Stilreferenz: `01-map-overview-city-v1.png`. Bild 1 ist das Bearbeitungsziel, Bild 2 dient ausschließlich als Stadt-/Scooter-/HUD-Stilreferenz, nicht für Kamerawinkel oder Menülayout.

```text
Use original purple-header three-card Trail shop layout as a Kukurin upgrades panel. Preserve centered modal size, three tall cards, large illustrations, color backgrounds gray/green/blue, red X and horizontal scrolling affordance. Title 'Kukurin-Upgrades'. The THREE cards represent consecutive levels of the same scooter speed upgrade, not extra progression systems: 'Stufe 1', 'Stufe 2', 'Stufe 3'. Show same black/orange scooter illustration in every card. Card labels '25 km/h', '30 km/h', '35 km/h'. First green button 'Aktuell', second '$250 – Verbessern', third '$750 – Verbessern'. Small footer 'Beispielwerte'. No trails, personal running speed, batteries, stamina or fuel. Background same blurred urban plots.
```

## 07-scooter-station-city-v1.png

Bearbeitungsziel: `references/steal-an-egg/screenshots/07-training-and-upgrades.png`.
Zusätzliche Stilreferenz: `01-map-overview-city-v1.png`. Bild 1 ist das Bearbeitungsziel, Bild 2 dient ausschließlich als Stadt-/Scooter-/HUD-Stilreferenz, nicht für Kamerawinkel oder Menülayout.

```text
Preserve the original close ground-level view: central blue money/s leaderboard against rear wall, fenced player courtyard to right, upgrade station to left foreground. Replace treadmill with compact Kukurin repair/upgrade pad on sidewalk, black/orange standing scooter and small repair stand. Upgrade sign 'Kukurin verbessern', 'Stufe 1 > Stufe 2', '$250'. Keep blue leaderboard titled 'MEISTES GELD/s', use generic player labels rather than original usernames. Replace free treasure chest with a simple decorative scooter parking rack; do not add reward mechanic. Buildings behind the station replace original tall bare walls, keep scene layout. Green floating income labels within pet plot. Show readable scooter without excessive props.
```

## 09-base-upgrade-city-v1.png

Bearbeitungsziel: `references/steal-an-egg/screenshots/09-base-upgrade.png`.
Zusätzliche Stilreferenz: `01-map-overview-city-v1.png`. Bild 1 ist das Bearbeitungsziel, Bild 2 dient ausschließlich als Stadt-/Scooter-/HUD-Stilreferenz, nicht für Kamerawinkel oder Menülayout.

```text
Preserve original third-person ground-level perspective directly outside a rectangular fenced pet courtyard, low gold/yellow fence and left upgrade sign. Place blocky avatar on black/orange Kukurin in foreground instead of banana-shaped avatar, still looking into courtyard. Keep egg/pet income labels inside plot. Asphalt sidewalk outside, grassy inner courtyard, low-rise colorful city facades replace high bare perimeter. Left sign 'Tiergehege verbessern', 'Stufe 1 > Stufe 2', '$500' as illustrative UI. Replace original right event billboard with a simple 'KUKURIN' scooter parking sign, no countdown/event. HUD consistent with other outputs.
```
