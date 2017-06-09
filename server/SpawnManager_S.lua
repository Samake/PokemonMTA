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
	for index, bike in pairs(getElementsByType("BIKESPAWN")) do
		if (bike) then
			
			local bikeProperties = {}
			bikeProperties.id = index
			bikeProperties.x = tonumber(bike:getData("posX") or 0)
			bikeProperties.y = tonumber(bike:getData("posY") or 0)
			bikeProperties.z = tonumber(bike:getData("posZ") or 0)
			bikeProperties.rx = tonumber(bike:getData("rotX") or 0)
			bikeProperties.ry = tonumber(bike:getData("rotY") or 0)
			bikeProperties.rz = tonumber(bike:getData("rotZ") or 0)
			
			if (not self.bikes[bikeProperties.id]) then
				self.bikes[bikeProperties.id] = new(Bikes_S, self, bikeProperties)
			end
		end
	end
end


function SpawnManager_S:spawnPokeSpawn()
	for index, pokeSpawn in pairs(getElementsByType("POKESPAWN")) do
		if (pokeSpawn) then
		
			local pokeSpawnProperties = {}
			pokeSpawnProperties.id = index
			pokeSpawnProperties.x = tonumber(pokeSpawn:getData("posX") or 0)
			pokeSpawnProperties.y = tonumber(pokeSpawn:getData("posY") or 0)
			pokeSpawnProperties.z = tonumber(pokeSpawn:getData("posZ") or 0)
			pokeSpawnProperties.radius = tonumber(pokeSpawn:getData("radius") or 15)
			pokeSpawnProperties.type = pokeSpawn:getData("type") or "ground"
			pokeSpawnProperties.count = tonumber(pokeSpawn:getData("count") or 1)
			
			if (not self.pokeSpawns[pokeSpawnProperties.id]) then
				self.pokeSpawns[pokeSpawnProperties.id] = new(PokeSpawn_S, self, pokeSpawnProperties)
			end
		end
	end
end


function SpawnManager_S:spawnChests()
	for index, chest in pairs(getElementsByType("CHESTSPAWN")) do
		if (chest) then
			
			local chestProperties = {}
			chestProperties.id = index
			chestProperties.x = tonumber(chest:getData("posX") or 0)
			chestProperties.y = tonumber(chest:getData("posY") or 0)
			chestProperties.z = tonumber(chest:getData("posZ") or 0)
			chestProperties.rx = tonumber(chest:getData("rotX") or 0)
			chestProperties.ry = tonumber(chest:getData("rotY") or 0)
			chestProperties.rz = tonumber(chest:getData("rotZ") or 0)
			
			if (not self.chests[chestProperties.id]) then
				self.chests[chestProperties.id] = new(Chest_S, self, chestProperties)
			end
		end
	end
end


function SpawnManager_S:spawnNPCs()
	for index, npc in pairs(getElementsByType("NPCSPAWN")) do
		if (npc) then
			
			local npcProperties = {}
			npcProperties.id = index
			npcProperties.modelID = tonumber(npc:getData("skin") or 12)
			npcProperties.x = tonumber(npc:getData("posX") or 0)
			npcProperties.y = tonumber(npc:getData("posY") or 0)
			npcProperties.z = tonumber(npc:getData("posZ") or 0)
			npcProperties.rx = tonumber(npc:getData("rotX") or 0)
			npcProperties.ry = tonumber(npc:getData("rotY") or 0)
			npcProperties.rz = tonumber(npc:getData("rotZ") or 0)
			npcProperties.radius = tonumber(npc:getData("radius") or 0)
			npcProperties.isTrainer = npc:getData("isTrainer") or "false"
			npcProperties.isVendor = npc:getData("isVendor") or "false"
			npcProperties.reputation = npc:getData("reputation") or "good"
			npcProperties.name = NPC_Helper:getRandomName(npcProperties.modelID) or "UNKNOWN"
			npcProperties.sex = NPC_Helper:getSex(npcProperties.modelID) or "female"
			
			if (not self.npcs[npcProperties.id]) then
				self.npcs[npcProperties.id] = new(NPC_S, self, npcProperties)
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
