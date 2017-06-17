PokemonManager_S = inherit(Singleton)

function PokemonManager_S:constructor()

	self.pokemonInstances = {}
	
	self:initManager()
	self.count = 0
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("PokemonManager_S was started.")
	end
end

function PokemonManager_S:initManager()
	
end


function PokemonManager_S:addPokemon(pokemonIndex, x, y, z, rot, dimension, radius, level, life, power, owner)
	if (pokemonIndex) and (Pokedex) then

		if (Pokedex[pokemonIndex]) then
			local pokedexCluster = Pokedex[pokemonIndex]
			
			local pokemonBluePrint = {}
			pokemonBluePrint.id = self:getFreeID()
			pokemonBluePrint.modelID = pokedexCluster.modelID
			pokemonBluePrint.name = pokedexCluster.name
			pokemonBluePrint.type = pokedexCluster.type
			pokemonBluePrint.legendary = pokedexCluster.legendary
			pokemonBluePrint.size = pokedexCluster.size
			pokemonBluePrint.soundFile = pokedexCluster.soundFile
			pokemonBluePrint.icon = pokedexCluster.icon
			pokemonBluePrint.x = x or 0
			pokemonBluePrint.y = y or 0
			pokemonBluePrint.z = z or 0
			pokemonBluePrint.rot = rot or math.random(1, 360)
			pokemonBluePrint.dimension = dimension or 0
			pokemonBluePrint.radius = radius or 1
			pokemonBluePrint.level = level or math.random(1, 100)
			pokemonBluePrint.life = life or math.random(1, 100)
			pokemonBluePrint.power = power or math.random(1, 100)
			pokemonBluePrint.owner = owner
		
			if (not self.pokemonInstances[pokemonBluePrint.id]) then
				self.pokemonInstances[pokemonBluePrint.id] = Pokemon_S:new(pokemonBluePrint)
				
				return self.pokemonInstances[pokemonBluePrint.id]
			end
		end
	end
	
	return nil
end


function PokemonManager_S:deletePokemon(id)
	if (id) then
		if (self.pokemonInstances[id]) then
			self.pokemonInstances[id]:delete()
			self.pokemonInstances[id] = nil
		end
	end
end


function PokemonManager_S:update()
	for index, instance in pairs(self.pokemonInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function PokemonManager_S:getFreeID()
	for index, instance in pairs(self.pokemonInstances) do
		if (not instance) then
			return index
		end
	end
	
	return #self.pokemonInstances + 1
end


function PokemonManager_S:clear()
	for index, instance in pairs(self.pokemonInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
end


function PokemonManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("PokemonManager_S was deleted.")
	end
end

