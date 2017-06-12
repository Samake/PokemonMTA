PokeSpawnManager_S = inherit(Singleton)

function PokeSpawnManager_S:constructor()

	self.pokeSpawnInstances = {}
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("PokeSpawnManager_S was started.")
	end
end

function PokeSpawnManager_S:initManager()
	
	self:initChests()
end


function PokeSpawnManager_S:initChests()
	local count = 0
	
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
			
			if (not self.pokeSpawnInstances[pokeSpawnProperties.id]) then
				self.pokeSpawnInstances[pokeSpawnProperties.id] = PokeSpawn_S:new(pokeSpawnProperties)
				count = count + 1
			end
		end
	end
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("PokeSpawnManager_S: " .. count .. " pokespawn instances created!")
	end
end


function PokeSpawnManager_S:update()
	for index, instance in pairs(self.pokeSpawnInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function PokeSpawnManager_S:clear()
	for index, instance in pairs(self.pokeSpawnInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
end


function PokeSpawnManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("PokeSpawnManager_S was deleted.")
	end
end

