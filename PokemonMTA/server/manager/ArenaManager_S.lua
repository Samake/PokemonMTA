ArenaManager_S = inherit(Singleton)

function ArenaManager_S:constructor()

	self.arenas = {}
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ArenaManager_S was started.")
	end
end

function ArenaManager_S:initManager()
	
	self:loadArenas()
end


function ArenaManager_S:loadArenas()
	count = 0
	
	for index, arena in pairs(getElementsByType("ARENA")) do
		if (arena) then
			
			local arenaProperties = {}
			arenaProperties.id = index
			arenaProperties.x = tonumber(arena:getData("posX") or 0)
			arenaProperties.y = tonumber(arena:getData("posY") or 0)
			arenaProperties.z = tonumber(arena:getData("posZ") or 0)
			arenaProperties.name = arena:getData("name") or "UNKOWN ARENA"
			arenaProperties.type = arena:getData("type") or "village"
			
			table.insert(self.arenas, arenaProperties)
			count = count + 1
		end
	end

	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ArenaManager_S: " .. count .. " arenas were found!")
	end
end


function ArenaManager_S:getNearestArena(x, y, z)

	local myArena = nil
	local distance = 6000
	
	if (x) and (y) and (z) then
		for i = 1, #self.arenas do
			if (self.arenas[i]) then
				local currentDistance = getDistanceBetweenPoints3D (x, y, z, self.arenas[i].x, self.arenas[i].y, self.arenas[i].z)
				
				if (currentDistance) then
					if (currentDistance < distance) then
						distance = currentDistance
						myArena = self.arenas[i]
					end
				end
			end
		end
	end
	
	return myArena
end


function ArenaManager_S:clear()
	for index, arena in pairs(self.arenas) do
		if (arena) then
			arena = nil
		end
	end
	
	self.arenas = {}
end


function ArenaManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ArenaManager_S was deleted.")
	end
end

