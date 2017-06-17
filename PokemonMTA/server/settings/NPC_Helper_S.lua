NPC_Helper = {}
local names = {}
local animations = {}

local maleIDs = {15, 17, 21, 24, 27, 28, 29, 32, 34}
local femaleIDs = {12, 13, 14, 16, 18, 19, 20, 22, 23, 25, 26, 30, 31, 33, 35}

names["male"] = {"Elio", "Brendan", "Guzma", "Gladion", "Laxxter", "Lysandre", "Clemont", "Ash"}
names["female"] = {"Selene", "Acerola", "Luna", "May", "Wally", "Cynthia", "Serena", "Plumeria", "Lillie", "Mallow", "Misty", "Corni", "Bonnie", "Mei"}

animations.default = {}

animations.pokemon = {}
animations.pokemon.male = {}
animations.pokemon.female = {}

animations.npc = {}
animations.npc.male = {}
animations.npc.female = {}


function NPC_Helper:getRandomPed()
	local sex = math.random(1, 2)
	
	if (sex == 1) then
		local randomID = math.random(1, #maleIDs)
		
		if (maleIDs[randomID]) then
			return maleIDs[randomID]
		end
	else
		local randomID = math.random(1, #femaleIDs)
		
		if (femaleIDs[randomID]) then
			return femaleIDs[randomID]
		end
	end
	
	return 12
end


function NPC_Helper:getRandomName(id)
	if (id) then
		local gender = NPC_Helper:getGender(id)
		
		if (gender) then
			if (names[gender]) then
				return names[gender][math.random(1, #names[gender])]
			end
		end
		
		return "UNKNOWN"
	end
end


function NPC_Helper:getNPCAnimationSet(gender)
	if (gender) then
		if (animations.npc[gender]) then
			return animations.npc[gender]
		end
	end
	
	return animations.default
end


function NPC_Helper:getPokemonAnimationSet(gender)
	if (gender) then
		if (animations.pokemon[gender]) then
			return animations.pokemon[gender]
		end
	end
	
	return animations.default
end


function NPC_Helper:getGender(id)
	if (id) then
		for index, genderID in pairs(maleIDs) do
			if (genderID) then
				if (id == genderID) then
					return "male"
				end
			end
		end
		
		for index, genderID in pairs(femaleIDs) do
			if (genderID) then
				if (id == genderID) then
					return "female"
				end
			end
		end
	end
end