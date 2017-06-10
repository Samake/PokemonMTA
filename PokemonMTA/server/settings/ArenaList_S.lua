--[[
	Filename: ArenaList_S.lua
	Authors: Sam@ke
--]]

ArenaList = {}
Arena = {}

ArenaList[1] = {name = "Verdant Meadows", type = "desert", x = 330.5, y = 2500, z = 16.5}
ArenaList[2] = {name = "Palomino Creek", type = "village", x = 2464.5, y = 41.8, z = 26.4}

function Arena:getNearest(x, y, z)

	local myArena = nil
	local distance = 6000
	
	if (x) and (y) and (z) then
		for i = 1, #ArenaList do
			if (ArenaList[i]) then
				local currentDistance = getDistanceBetweenPoints3D (x, y, z, ArenaList[i].x, ArenaList[i].y, ArenaList[i].z)
				
				if (currentDistance) then
					if (currentDistance < distance) then
						distance = currentDistance
						myArena = ArenaList[i]
					end
				end
			end
		end
	end
	
	return myArena
end