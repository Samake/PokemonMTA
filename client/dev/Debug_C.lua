--[[
	Filename: Debug_C.lua
	Authors: Sam@ke
--]]

Debug_C = {}

function Debug_C:constructor(parent)

	self.coreClass = parent
	self.player = getLocalPlayer()
	
	self:init()
	
	mainOutput("Debug_C was started.")
end


function Debug_C:init()

end


function Debug_C:update(delta)
	if (self.coreClass.isDebug == true) then
		for index, pokeSpawn in pairs(getElementsByType("PokeSpawn_S")) do
			if (pokeSpawn) then
				self:drawPokeSpawn(pokeSpawn)
			end
		end
	end
end


function Debug_C:drawPokeSpawn(pokeSpawn)
	if (pokeSpawn) then
		local pos = pokeSpawn:getPosition()
		local radius = pokeSpawn:getData("radius")
		local color = tocolor(255, 165, 55, 255)
		local thickness = 8
		
		if (pos) and (radius) then
			radius = tonumber(radius)
			local corner1 = {x = pos.x - radius / 2, y = pos.y - radius / 2, z = pos.z}
			local corner2 = {x = pos.x + radius / 2, y = pos.y - radius / 2, z = pos.z}
			local corner3 = {x = pos.x + radius / 2, y = pos.y + radius / 2, z = pos.z}
			local corner4 = {x = pos.x - radius / 2, y = pos.y + radius / 2, z = pos.z}
			local top = {x = pos.x, y = pos.y, z = pos.z + radius / 2}
			
			-- // ground // --
			dxDrawLine3D(corner1.x, corner1.y, corner1.z, corner2.x, corner2.y, corner2.z, color, thickness, true)
			dxDrawLine3D(corner2.x, corner2.y, corner2.z, corner3.x, corner3.y, corner3.z, color, thickness, true)
			dxDrawLine3D(corner3.x, corner3.y, corner3.z, corner4.x, corner4.y, corner4.z, color, thickness, true)
			dxDrawLine3D(corner4.x, corner4.y, corner4.z, corner1.x, corner1.y, corner1.z, color, thickness, true)
			
			-- // pyramid // --
			dxDrawLine3D(corner1.x, corner1.y, corner1.z, top.x, top.y, top.z, color, thickness, true)
			dxDrawLine3D(corner2.x, corner2.y, corner2.z, top.x, top.y, top.z, color, thickness, true)
			dxDrawLine3D(corner3.x, corner3.y, corner3.z, top.x, top.y, top.z, color, thickness, true)
			dxDrawLine3D(corner4.x, corner4.y, corner4.z, top.x, top.y, top.z, color, thickness, true)
		end
	end
end


function Debug_C:clear()
	
end


function Debug_C:destructor()
	self:clear()
	
	mainOutput("Debug_C was deleted.")
end
