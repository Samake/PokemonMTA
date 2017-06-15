PokeSpawn_S = inherit(Class)

function PokeSpawn_S:constructor(pokeSpawnProperties)

	self.id = pokeSpawnProperties.id
    self.x = pokeSpawnProperties.x
    self.y = pokeSpawnProperties.y
    self.z = pokeSpawnProperties.z
    self.radius = pokeSpawnProperties.radius or 10
	self.type = pokeSpawnProperties.type or "all"
	self.count = pokeSpawnProperties.count or 1
			
    self.isActive = "false"
	self.spawnTime = math.random(3000, 9000)
	
	self.pokemon = {}
	self.spawnCount = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeSpawn_S " .. self.id .. " was started.")
	end
end


function PokeSpawn_S:init()
	self.startTime = getTickCount()
 
end


function PokeSpawn_S:spawnPokemon()
	for i = 1, self.count do
		if (not self.pokemon[i]) and (Pokedex) then
			local x, y, z = getAttachedPosition(self.x, self.y, self.z, 0, 0, 0, math.random(0, self.radius), math.random(0, 360), 1)
			self.pokemon[i] = PokemonManager_S:getSingleton():addPokemon(math.random(1, #Pokedex), x, y, z, math.random(0, 360), 0, self.radius)
		end
	end
end

 
function PokeSpawn_S:update()
	self.currentTime = getTickCount()
	
	if (self.isActive == "false") then
		if (self.currentTime >= self.startTime + self.spawnTime) then
			self:activate()
		end
	end
end


function PokeSpawn_S:activate()
	if (self.isActive ~= "true") then
		self:spawnPokemon()
		self.isActive = "true"
	end
end


function PokeSpawn_S:clear()
	for index, pokemonClass in pairs(self.pokemon) do
		if (pokemonClass) then
			delete(pokemonClass)
			pokemonClass = nil
		end
	end
end


function PokeSpawn_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeSpawn_S " .. self.id .. " was deleted.")
	end
end
