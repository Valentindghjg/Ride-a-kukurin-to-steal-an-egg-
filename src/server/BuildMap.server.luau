-- Baut beim Serverstart die Map und verbindet die Weltwechsel-Platten.
-- Wird per Rojo nach ServerScriptService.KukurinServer synchronisiert.

local MapBuilder = require(script.Parent:WaitForChild("MapBuilder"))
local WorldPortals = require(script.Parent:WaitForChild("WorldPortals"))

local started = os.clock()
local ok, result = pcall(MapBuilder.build)

if ok then
	WorldPortals.setup(result)
	-- Signal für Dienste, die auf die fertige Map warten (z. B. EggService)
	workspace:SetAttribute("KukurinMapBereit", true)
	print(("[Kukurin] Map gebaut: %d Instanzen in %.2f s."):format(#result:GetDescendants(), os.clock() - started))
else
	warn("[Kukurin] Map konnte nicht gebaut werden: " .. tostring(result))
end
