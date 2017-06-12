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


function PokemonManager_S:addPokemon(pokemonBluePrint)
	if (pokemonBluePrint) then
		if (not self.pokemonInstances[pokemonBluePrint.id]) then
			self.pokemonInstances[pokemonBluePrint.id] = Pokemon_S:new(pokemonBluePrint)
		end
	end
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

