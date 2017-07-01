Debug_C = inherit(Singleton)

function Debug_C:constructor()

	self.player = getLocalPlayer()
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Debug_C was started.")
	end
end


function Debug_C:init()

end


function Debug_C:update(delta)
	if (isElement(self.player)) then
		self.playerPos = self.player:getPosition()
		self.zone = getZoneName(self.playerPos.x, self.playerPos.y, self.playerPos.z)
		
		if (Settings.debugEnabled == true) then
			for index, pokeSpawn in pairs(getElementsByType("POKESPAWN")) do
				if (pokeSpawn) then
					self:drawPokeSpawn(pokeSpawn)
				end
			end
			
			if (self.zone) and (WayPoints) then
				if (WayPoints[self.zone]) then
					for index, route in pairs(WayPoints[self.zone]) do
						if (route) then
							self:drawRoute(route)
						end
					end
				end
			end
			
			for index, npc in pairs(getElementsByType("NPC")) do
				if (npc) then
					self:drawPeds(npc)
				end
			end
			
			for index, pokemon in pairs(getElementsByType("POKEMON")) do
				if (pokemon) then
					self:drawPokemon(pokemon)
				end
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


function Debug_C:drawRoute(route)
	if (route) then
		
		local thickness = 5
			
		for i = 1, #route do
			if (route[i]) then
				dxDrawLine3D(route[i].x, route[i].y, route[i].z - 1, route[i].x, route[i].y, route[i].z + 1, tocolor(45, 90, 255, 255), thickness, true)
				dxDrawLine3D(route[i].x - 0.25, route[i].y, route[i].z + 0.5, route[i].x + 0.25, route[i].y, route[i].z + 0.5, tocolor(45, 255, 45, 255), thickness, true)
				dxDrawLine3D(route[i].x, route[i].y - 0.25, route[i].z + 0.5, route[i].x, route[i].y + 0.25, route[i].z + 0.5, tocolor(255, 45, 45, 255), thickness, true)
				
				local x1, y1, z1 = route[i].x, route[i].y, route[i].z
				local x2, y2, z2
				
				if (route[i + 1]) then
					x2, y2, z2 = route[i + 1].x, route[i + 1].y, route[i + 1].z
				else
					x2, y2, z2 = route[1].x, route[1].y, route[1].z
				end
				
				if (x1) and (y1) and (z1) and (x2) and (y2) and (z2) then
					dxDrawLine3D(x1, y1, z1 + 0.5, x2, y2, z2 + 0.5, tocolor(220, 220, 45, 255), thickness * 0.5, true)
				end
			end
		end
	end
end


function Debug_C:drawPeds(npc)
	if (isElement(npc)) then
		local pos = npc:getPosition()
		local color = tocolor(255, 255, 255, 255)
		local thickness = 8
		
		dxDrawLine3D(pos.x, pos.y, pos.z - 1, pos.x, pos.y, pos.z + 15, color, thickness, true)
	end
end


function Debug_C:drawPokemon(pokemon)
	if (isElement(pokemon)) then
		local pos = pokemon:getPosition()
		local color = tocolor(45, 45, 220, 255)
		local thickness = 8
		
		dxDrawLine3D(pos.x, pos.y, pos.z - 1, pos.x, pos.y, pos.z + 15, color, thickness, true)
	end
end


function Debug_C:clear()
	
end


function Debug_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Debug_C was deleted.")
	end
end
