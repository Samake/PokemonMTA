Player_C = inherit(Singleton)

function Player_C:constructor()

	self.player = getLocalPlayer()
	
	self.throwPower = 0
	self.maxThrowPower = 1.8
	self.isThowing = "false"
	self.animationReset = "false"
	
	self.currentCount = 0
	self.startCount = 0
	
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
	self.m_ThrowPokeBall = bind(self.throwPokeBall, self)
	
	self.m_SyncPokemon = bind(self.syncPokemon, self)
	
	bindKey(Bindings["POKESLOT1"], "down", self.m_TogglePokeSlot1)
	bindKey(Bindings["POKESLOT2"], "down", self.m_TogglePokeSlot2)
	bindKey(Bindings["POKESLOT3"], "down", self.m_TogglePokeSlot3)
	bindKey(Bindings["POKESLOT4"], "down", self.m_TogglePokeSlot4)
	bindKey(Bindings["POKESLOT5"], "down", self.m_TogglePokeSlot5)
	bindKey(Bindings["POKESLOT6"], "down", self.m_TogglePokeSlot6)
	bindKey(Bindings["THROWPOKEBALL"], "up", self.m_ThrowPokeBall)
	
	addEvent("DOSYNCPLAYERPOKEMON", true)
	addEventHandler("DOSYNCPLAYERPOKEMON", root, self.m_SyncPokemon)
end


function Player_C:update(delta)
	self.currentCount = getTickCount()
	
	if (getKeyState(Bindings["THROWPOKEBALL"])) then
		if (self.throwPower < self.maxThrowPower) then
			self.throwPower = self.throwPower + 0.025
		else
			self.throwPower = self.maxThrowPower
		end
		
		if (self.isThowing == "false") then
			self.isThowing = "true"
			self.player:setAnimation("grenade","weapon_start_throw", -1, false)
			self.animationReset = "false"
		end
	else
		if (self.isThowing == "true") then
			self.player:setAnimation("grenade","weapon_throw", -1, false)
			self.throwPower = 0
			self.isThowing = "false"
			self.startCount = getTickCount()
		end
		
		if (self.animationReset == "false") then
			if (self.currentCount >= self.startCount + 1000) then
				self.player:setAnimation()
				self.animationReset = "true"
			end
		end
	end
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


function Player_C:throwPokeBall()
	if (isElement(self.player)) then
		local playerPos = self.player:getPosition()
		local playerRot = self.player:getRotation()
		local x, y, z = getAttachedPosition(playerPos.x, playerPos.y, playerPos.z, playerRot.x, playerRot.y, playerRot.z, 5, 0, 0)
		
		local throwDetails = {}
		throwDetails.player = self.player
		throwDetails.x = x
		throwDetails.y = y 
		throwDetails.z = z
		throwDetails.power = self.throwPower
		
		outputChatBox("Pokeball thrown with power " .. self.throwPower)
	end
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
	unbindKey(Bindings["THROWPOKEBALL"], "up", self.m_ThrowPokeBall)
end


function Player_C:destructor()
	self:clear()

	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_C was deleted.")
	end
end
