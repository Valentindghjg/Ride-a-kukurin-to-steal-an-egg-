-- Umwandlung zwischen Spielerattributen und gespeichertem Spielstand.
-- collect() liest den Stand, apply() schreibt einen geladenen Stand zurück.
-- Geladene Werte werden geprüft und begrenzt, damit ein beschädigter oder
-- veralteter Stand das Spiel nicht kaputt macht.

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shared = ReplicatedStorage:WaitForChild("KukurinShared")
local Config = require(shared:WaitForChild("KukurinConfig"))
local Katalog = require(shared:WaitForChild("SpielKatalog"))
local Training = require(shared:WaitForChild("Training"))
local PlayerStats = require(script.Parent:WaitForChild("PlayerStats"))
local A = Config.Attributes

local SaveData = {}
SaveData.VERSION = 1

local function decode(raw: unknown): any
	if type(raw) ~= "string" then
		return nil
	end
	local ok, value = pcall(HttpService.JSONDecode, HttpService, raw)
	return if ok then value else nil
end

local function number(value: unknown, fallback: number, min: number, max: number): number
	local n = tonumber(value)
	if not n or n ~= n then
		return fallback
	end
	return math.clamp(n, min, max)
end

export type Data = {
	version: number,
	geld: number,
	level: number,
	training: number,
	rebirths: number,
	modell: string,
	tierindex: { string },
	eier: { [string]: number },
	gehege: { plaetze: number, tiere: { string } },
}

function SaveData.collect(player: Player): Data
	local pen = decode(player:GetAttribute(A.Pen))
	local eggs = decode(player:GetAttribute(A.Eggs))
	local index = decode(player:GetAttribute(A.AnimalIndex))
	return {
		version = SaveData.VERSION,
		geld = math.floor(player:GetAttribute(A.Money) or 0),
		level = player:GetAttribute(A.Level) or 1,
		training = player:GetAttribute(A.Training) or 0,
		rebirths = player:GetAttribute(A.Rebirths) or 0,
		modell = player:GetAttribute(A.Model) or Katalog.Modelle[1].id,
		tierindex = if type(index) == "table" then index else {},
		eier = if type(eggs) == "table" then eggs else {},
		gehege = {
			plaetze = if type(pen) == "table" then tonumber(pen.plaetze) or Katalog.Gehege.startPlaetze else Katalog.Gehege.startPlaetze,
			tiere = if type(pen) == "table" and type(pen.tiere) == "table" then pen.tiere else {},
		},
	}
end

-- Prüft einen geladenen Stand und schreibt ihn in die Attribute
function SaveData.apply(player: Player, data: any)
	if type(data) ~= "table" then
		return
	end
	local rebirths = math.floor(number(data.rebirths, 0, 0, 1000))
	local modell = Katalog.modell(data.modell)
	if rebirths < modell.rebirth then
		modell = Katalog.Modelle[1] -- nur freigeschaltete Modelle
	end

	local index = {}
	if type(data.tierindex) == "table" then
		for _, id in data.tierindex do
			if Katalog.TierNachId[id] and not table.find(index, id) then
				table.insert(index, id)
			end
		end
	end

	local eggs = {}
	if type(data.eier) == "table" then
		for id, count in data.eier do
			local n = math.floor(number(count, 0, 0, 9999))
			if Katalog.EiNachId[id] and n > 0 then
				eggs[id] = n
			end
		end
	end

	local slots = math.floor(number(type(data.gehege) == "table" and data.gehege.plaetze, Katalog.Gehege.startPlaetze, Katalog.Gehege.startPlaetze, Katalog.Gehege.maxPlaetze))
	local animals = {}
	if type(data.gehege) == "table" and type(data.gehege.tiere) == "table" then
		for _, id in data.gehege.tiere do
			if Katalog.TierNachId[id] and #animals < slots then
				table.insert(animals, id)
			end
		end
	end

	player:SetAttribute(A.Money, math.floor(number(data.geld, 0, 0, 1e15)))
	player:SetAttribute(A.Rebirths, rebirths)
	player:SetAttribute(A.Model, modell.id)
	PlayerStats.setTraining(player, math.floor(number(data.level, 1, 1, Training.MAX_LEVEL)), number(data.training, 0, 0, 0.999))
	player:SetAttribute(A.AnimalIndex, HttpService:JSONEncode(index))
	player:SetAttribute(A.Eggs, HttpService:JSONEncode(eggs))
	player:SetAttribute(A.Pen, HttpService:JSONEncode({ plaetze = slots, tiere = animals }))
end

return SaveData
