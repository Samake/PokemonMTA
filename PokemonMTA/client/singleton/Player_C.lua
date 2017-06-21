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
	self.m_TogglePokeSlot1 = bind(self.togglePokeSlot1, self)
	self.m_TogglePokeSlot2 = bind(self.togglePokeSlot2, self)
	self.m_TogglePokeSlot3 = bind(self.togglePokeSlot3, self)
	self.m_TogglePokeSlot4 = bind(self.togglePokeSlot4, self)
	self.m_TogglePokeSlot5 = bind(self.togglePokeSlot5, self)
	self.m_TogglePokeSlot6 = bind(self.togglePokeSlot6, self)
	
	self.m_SyncPokemon = bind(self.syncPokemon, self)
	
	bindKey(Bindings["POKESLOT1"], "down", self.m_TogglePokeSlot1)
	bindKey(Bindings["POKESLOT2"], "down", self.m_TogglePokeSlot2)
	bindKey(Bindings["POKESLOT3"], "down", self.m_TogglePokeSlot3)
	bindKey(Bindings["POKESLOT4"], "down", self.m_TogglePokeSlot4)
	bindKey(Bindings["POKESLOT5"], "down", self.m_TogglePokeSlot5)
	bindKey(Bindings["POKESLOT6"], "down", self.m_TogglePokeSlot6)
	
	addEvent("DOSYNCPLAYERPOKEMON", true)
	addEventHandler("DOSYNCPLAYERPOKEMON", root, self.m_SyncPokemon)
end


function Player_C:update(delta)

end


function Player_C:togglePokeSlot1()
	triggerServerEvent("DOTOGGLECOMPANION", self.player, 1)
end


function Player_C:togglePokeSlot2()
	triggerServerEvent("DOTOGGLECOMPANION", self.player, 2)
end


function Player_C:togglePokeSlot3()
	triggerServerEvent("DOTOGGLECOMPANION", self.player, 3)
end


function Player_C:togglePokeSlot4()
	triggerServerEvent("DOTOGGLECOMPANION", self.player, 4)
end


function Player_C:togglePokeSlot5()
	triggerServerEvent("DOTOGGLECOMPANION", self.player, 5)
end


function Player_C:togglePokeSlot6()
	triggerServerEvent("DOTOGGLECOMPANION", self.player, 6)
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
	unbindKey(Bindings["POKESLOT1"], "down", self.m_TogglePokeSlot1)
	unbindKey(Bindings["POKESLOT2"], "down", self.m_TogglePokeSlot2)
	unbindKey(Bindings["POKESLOT3"], "down", self.m_TogglePokeSlot3)
	unbindKey(Bindings["POKESLOT4"], "down", self.m_TogglePokeSlot4)
	unbindKey(Bindings["POKESLOT5"], "down", self.m_TogglePokeSlot5)
	unbindKey(Bindings["POKESLOT6"], "down", self.m_TogglePokeSlot6)
end


function Player_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_C was deleted.")
	end
end
