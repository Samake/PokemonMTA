--[[
	Filename: NPC_Helper_S.lua
	Authors: Sam@ke
--]]


NPC_Helper = {}
local names = {}


local maleIDs = {15, 17, 21, 24, 27, 28, 29, 32, 34}
local femaleIDs = {12, 13, 14, 16, 18, 19, 20, 22, 23, 25, 26, 30, 31, 33, 35}

names["male"] = {"Elio", "Brendan", "Guzma", "Gladion", "Laxxter", "Lysandre", "Clemont", "Ash"}
names["female"] = {"Selene", "Acerola", "Luna", "May", "Wally", "Cynthia", "Serena", "Plumeria", "Lillie", "Mallow", "Misty", "Corni", "Bonnie", "Mei"}

function NPC_Helper:getRandomName(id)
	if (id) then
		local sex = NPC_Helper:getSex(id)
		
		if (sex) then
			if (names[sex]) then
				return names[sex][math.random(0, #names[sex])]
			end
		end
		
		return "UNKNOWN"
	end
end


function NPC_Helper:getSex(id)
	if (id) then
		for index, sexID in pairs(maleIDs) do
			if (sexID) then
				if (id == sexID) then
					return "male"
				end
			end
		end
		
		for index, sexID in pairs(femaleIDs) do
			if (sexID) then
				if (id == sexID) then
					return "female"
				end
			end
		end
	end
end