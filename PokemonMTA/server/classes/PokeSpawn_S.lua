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
			
			local rawPokemon = Pokedex[math.random(1, #Pokedex)]
			
			if (rawPokemon) then
				local x, y, z = getAttachedPosition(self.x, self.y, self.z, 0, 0, 0, math.random(0, self.radius / 2), math.random(0, 360), 1)
				
				local pokemonBluePrint = {}
				pokemonBluePrint.spawn = self
				pokemonBluePrint.owner = nil
				pokemonBluePrint.id = self.id .. ":" .. i .. ":" .. rawPokemon.name
				pokemonBluePrint.modelID = rawPokemon.modelID
				pokemonBluePrint.name = rawPokemon.name
				pokemonBluePrint.type = rawPokemon.type
				pokemonBluePrint.legendary = rawPokemon.legendary
				pokemonBluePrint.size = rawPokemon.size
				pokemonBluePrint.level = math.random(1, 55)
				pokemonBluePrint.power = math.random(5, 100)
				pokemonBluePrint.x = x
				pokemonBluePrint.y = y
				pokemonBluePrint.z = z
				pokemonBluePrint.rot = math.random(0, 360)
				pokemonBluePrint.radius = self.radius
				pokemonBluePrint.sound = rawPokemon.sound
				
				PokemonManager_S:getSingleton():addPokemon(pokemonBluePrint)
			end
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
	
	for index, pokemonClass in pairs(self.pokemon) do
		if (pokemonClass) then
			pokemonClass:update()
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
