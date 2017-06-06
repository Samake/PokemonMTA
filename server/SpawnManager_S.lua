--[[
	Filename: SpawnManager_S.lua
	Authors: Sam@ke
--]]

SpawnManager_S = {}

function SpawnManager_S:constructor(parent)

    self.coreClass = parent
	
	self.bikes = {}
	self.pokeSpawns = {}
	self.chests = {}
	self.npcs = {}

	self.pokeSpawnsPerPlayer = 5

	self:init()

	mainOutput("SpawnManager_S was started.")
end


function SpawnManager_S:init()
	self:spawnBikes()
	self:spawnPokeSpawn()
	self:spawnChests()
	self:spawnNPCs()
end


function SpawnManager_S:spawnBikes()
	if (SpawnList) then
		if (SpawnList.bikes) then
			for index, bikeSpawn in pairs(SpawnList.bikes) do
				if (bikeSpawn) then
				
					local bikeProperties = {}
					bikeProperties.id = index
					bikeProperties.x = bikeSpawn.x
					bikeProperties.y = bikeSpawn.y
					bikeProperties.z = bikeSpawn.z
					bikeProperties.rx = bikeSpawn.rx
					bikeProperties.ry = bikeSpawn.ry
					bikeProperties.rz = bikeSpawn.rz
					
					if (not self.bikes[bikeProperties.id]) then
						self.bikes[bikeProperties.id] = new(Bikes_S, self, bikeProperties)
					end
				end
			end
		end
	end
end


function SpawnManager_S:spawnPokeSpawn()
	if (SpawnList) then
		if (SpawnList.pokespawn) then
			for index, pokeSpawn in pairs(SpawnList.pokespawn) do
				if (pokeSpawn) then
				
					local pokeSpawnProperties = {}
					pokeSpawnProperties.id = index
					pokeSpawnProperties.x = pokeSpawn.x
					pokeSpawnProperties.y = pokeSpawn.y
					pokeSpawnProperties.z = pokeSpawn.z
					pokeSpawnProperties.radius = pokeSpawn.radius
					pokeSpawnProperties.type = pokeSpawn.type
					pokeSpawnProperties.count = pokeSpawn.count
					
					if (not self.pokeSpawns[pokeSpawnProperties.id]) then
						self.pokeSpawns[pokeSpawnProperties.id] = new(PokeSpawn_S, self, pokeSpawnProperties)
					end
				end
			end
		end
	end
end


function SpawnManager_S:spawnChests()
	if (SpawnList) then
		if (SpawnList.chests) then
			for index, chest in pairs(SpawnList.chests) do
				if (chest) then
				
					local chestProperties = {}
					chestProperties.id = index
					chestProperties.x = chest.x
					chestProperties.y = chest.y
					chestProperties.z = chest.z
					chestProperties.rx = chest.rx
					chestProperties.ry = chest.ry
					chestProperties.rz = chest.rz
					
					if (not self.chests[chestProperties.id]) then
						self.chests[chestProperties.id] = new(Chest_S, self, chestProperties)
					end
				end
			end
		end
	end
end


function SpawnManager_S:spawnNPCs()
	if (SpawnList) then
		if (SpawnList.npcs) then
			for index, npc in pairs(SpawnList.npcs) do
				if (npc) then
				
					local npcProperties = {}
					npcProperties.id = index
					npcProperties.modelID = npc.modelID
					npcProperties.name = npc.name
					npcProperties.x = npc.x
					npcProperties.y = npc.y
					npcProperties.z = npc.z
					npcProperties.rx = npc.rx
					npcProperties.ry = npc.ry
					npcProperties.rz = npc.rz
					
					if (not self.npcs[npcProperties.id]) then
						self.npcs[npcProperties.id] = new(NPC_S, self, npcProperties)
					end
				end
			end
		end
	end
end


function SpawnManager_S:getNPCClass(id)
	if (id) then
		if (self.npcs[id]) then
			return self.npcs[id]
		end
	end
	
	return nil
end


function SpawnManager_S:update()
	for index, bike in pairs(self.bikes) do
		if (bike) then
			bike:update()
		end
	end
	
	for index, pokeSpawn in pairs(self.pokeSpawns) do
		if (pokeSpawn) then
			pokeSpawn:update()
		end
	end
	
	for index, chest in pairs(self.chests) do
		if (chest) then
			chest:update()
		end
	end
	
	for index, npc in pairs(self.npcs) do
		if (npc) then
			npc:update()
		end
	end
end


function SpawnManager_S:deletePokeSpawn(id)
	if (id) then
		if (self.pokeSpawns[id]) then
			delete(self.pokeSpawns[id])
			self.pokeSpawns[id] = nil
		end
	end
end


function SpawnManager_S:getFreePokeSpawnID()
	for index, pokeSpawn in pairs(self.pokeSpawns) do
		if (not pokeSpawn) then
			return index
		end
	end

	return #self.pokeSpawns + 1
end


function SpawnManager_S:clear()

	for index, bike in pairs(self.bikes) do
		if (bike) then
			delete(bike)
			bike = nil
		end
	end
	
	
	for index, pokeSpawn in pairs(self.pokeSpawns) do
		if (pokeSpawn) then
			delete(pokeSpawn)
			pokeSpawn = nil
		end
	end
	
	for index, chest in pairs(self.chests) do
		if (chest) then
			delete(chest)
			chest = nil
		end
	end
	
	for index, npc in pairs(self.npcs) do
		if (npc) then
			delete(npc)
			npc = nil
		end
	end
end


function SpawnManager_S:destructor()
	self:clear()
	
	mainOutput("SpawnManager_S was deleted.")
end
