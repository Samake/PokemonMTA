Player_C = inherit(Singleton)

function Player_C:constructor()

	self.player = getLocalPlayer()
	
	self.throwPower = 0
	self.maxThrowPower = 1.5
	self.isThrowing = "false"
	self.animationReset = "false"
	
	self.currentCount = 0
	self.startCount = 0
	
	self.pokeBall = nil
	
	self.pokemons = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Player_C was started.")
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
	
	if (isElement(self.player)) then
		self.playerPos = self.player:getPosition()
		self.playerRot = self.player:getRotation()
	end
	
	if (isElement(self.pokeBall)) then
		local x, y, z = self.player:getBonePosition(25)
		self.pokeBall:setPosition(x, y, z - 0.05)
	end
	
	if (getKeyState(Bindings["THROWPOKEBALL"])) then
		if (self.throwPower < self.maxThrowPower) then
			self.throwPower = self.throwPower + 0.025
		else
			self.throwPower = self.maxThrowPower
		end
		
		if (self.isThrowing == "false") then
			self:prepareThrowing()
		end
	else
		if (self.isThrowing == "true") then
			self:finishThrowing()
		end
		
		if (self.animationReset == "false") then
			if (self.currentCount >= self.startCount + 1000) then
				self.player:setAnimation()
				self.animationReset = "true"
			end
		end
	end
	
	self:updateThrowLight()
end


function Player_C:updateThrowLight()
	if (self.playerPos) and (self.playerRot) and (isElement(self.throwLight)) then
		local lx, ly, lz = getAttachedPosition(self.playerPos.x, self.playerPos.y, self.playerPos.z, self.playerRot.x, self.playerRot.y, self.playerRot.z, (20.5 / self.maxThrowPower) * self.throwPower, 0, 0)
		
		self.throwLight:setPosition(lx, ly, lz)
	end
end


function Player_C:prepareThrowing()
	self.isThrowing = "true"
	self.player:setAnimation("grenade","weapon_start_throw", -1, false)
	self.animationReset = "false"
	
	self:createPokeBall()
	self:createThrowLight()
end


function Player_C:finishThrowing()
	self.player:setAnimation("grenade","weapon_throw", -1, false)
	self.throwPower = 0
	self.isThrowing = "false"
	self.startCount = getTickCount()
	
	self:deletePokeBall()
	self:deleteThrowLight()
end


function Player_C:createPokeBall()
	if (not self.pokeBall) then
		local x, y, z = self.player:getBonePosition(25)
		self.pokeBall = createObject(1854, x, y, z - 0.05, math.random(1, 360), math.random(1, 360), math.random(1, 360))
	end
end

function Player_C:createThrowLight()
	if (self.playerPos) and (not self.throwLight) then
		self.throwLight = createMarker(self.playerPos.x, self.playerPos.y, self.playerPos.z, "corona", 0.35, 220, 220, 75, 190)
	end
end

function Player_C:deletePokeBall()
	if (self.pokeBall) then
		self.pokeBall:destroy()
		self.pokeBall = nil
	end
end


function Player_C:deleteThrowLight()
	if (self.throwLight) then
		self.throwLight:destroy()
		self.throwLight = nil
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
		local x, y, z = self.player:getBonePosition(25)
		
		local throwDetails = {}
		throwDetails.player = self.player
		throwDetails.x = x
		throwDetails.y = y 
		throwDetails.z = z + 0.2
		throwDetails.power = self.throwPower
		
		triggerServerEvent("PLAYERTHROWPOKEBALL", self.player, throwDetails)
		
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
		sendMessage("Player_C was deleted.")
	end
end
