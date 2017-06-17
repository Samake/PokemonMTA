Player_C = inherit(Singleton)

function Player_C:constructor()

	self.player = getLocalPlayer()
	
	self.pokemons = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_C was started.")
	end
end


function Player_C:init()
	self.m_ToggleCompanion = bind(self.toggleCompanion, self)
	self.m_SyncPokemon = bind(self.syncPokemon, self)
	
	bindKey(Bindings["COMPANION"], "down", self.m_ToggleCompanion)
	
	addEvent("DOSYNCPLAYERPOKEMON", true)
	addEventHandler("DOSYNCPLAYERPOKEMON", root, self.m_SyncPokemon)
end


function Player_C:update(delta)

end


function Player_C:toggleCompanion()
	triggerServerEvent("DOTOGGLECOMPANION", self.player)
end


function Player_C:syncPokemon(pokemons)
	if (pokemons) then
		self.pokemons = pokemons
	end
end


function Player_C:getPokemons()
	return self.pokemons
end


function Player_C:clear()
	removeEventHandler("DOSYNCPLAYERPOKEMON", root, self.m_SyncPokemon)
	unbindKey(Bindings["COMPANION"], "down", self.m_ToggleCompanion)
end


function Player_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_C was deleted.")
	end
end
