PokeBall_S = inherit(Class)

function PokeBall_S:constructor(pokeBallProperties)
	
	self.id = pokeBallProperties.id
	self.player = pokeBallProperties.player
	self.x = pokeBallProperties.x
	self.y = pokeBallProperties.y 
	self.z = pokeBallProperties.z
	self.rx = math.random(1, 360)
	self.ry = math.random(1, 360)
	self.rz = math.random(1, 360)
	self.power = pokeBallProperties.power

	self.modelID = 594
	
	self.currentCount = 0
	self.startCount = 0
	self.lifeTime = 4000
	
	self.mass = 1
	
	self.pokemon = nil
	self.pokemonClass = nil
	self.tryToCatch = false
	self.catchCount = 0
	self.catchTime = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("PokeBall_S " .. self.id .. " was started.")
	end
end


function PokeBall_S:init()
	if (not self.model) and (isElement(self.player)) then
		self.model = createVehicle(self.modelID, self.x, self.y, self.z, self.rx, self.ry, self.rz)
		self.model:setDamageProof(true)
		setVehicleHandling(self.model, "mass", self.mass)
		setVehicleLocked(self.model, true)
		setVehicleEngineState(self.model, false)
		
		if (not self.actionCol) then
			self.actionCol = createColSphere(self.x, self.y, self.z, 1.5)
		end
		
		
		if (self.model and self.actionCol) then
			self.actionCol:attach(self.model)
			
			self.m_OnColShapeHit = bind(self.onColShapeHit, self)
			self.m_OnColShapeLeave = bind(self.onColShapeLeave, self)
			
			if (not self.owner) then
				addEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
				addEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
			end
			
			self:setDimension(self.dimension)
		end
	end
	
	self.startCount = getTickCount()
	
	self:throwPokeBall()
end


function PokeBall_S:setDimension()
	self.model:setDimension(self.player:getDimension())
	self.actionCol:setDimension(self.player:getDimension())
end


function PokeBall_S:throwPokeBall()
	if (isElement(self.model)) and (isElement(self.player)) then
		local playerPos = self.player:getPosition()
		local playerRot = self.player:getRotation()
		local dx, dy, dz = getAttachedPosition(playerPos.x, playerPos.y, playerPos.z, playerRot.x, playerRot.y, playerRot.z, 5, 0, 0)
		local shootStrength = 0.05 * self.power
		
		self.model:setVelocity((dx - playerPos.x) * shootStrength, (dy - playerPos.y) * shootStrength, shootStrength * 2.5)
		self.model:setTurnVelocity(math.random(0, 5) / 50, math.random(0, 5) / 50, math.random(0, 5) / 50)	
	end
end


function PokeBall_S:update()
	self.currentCount = getTickCount()
	
	if (self.currentCount > self.startCount + self.lifeTime) then
		PokeBallManager_S:getSingleton():removePokeBall(self.id)
	end
	
	if (isElement(self.model)) then
		self:updatePosition()
		self:updateData()
		
		if (self.tryToCatch == true) then
			self:doCatchProcess()
		end
	end
end


function PokeBall_S:updatePosition()
	local modelPos = self.model:getPosition()
	self.x = modelPos.x
	self.y = modelPos.y
	self.z = modelPos.z
	
	local modelRot = self.model:getRotation()
	self.rx = modelRot.x
	self.ry = modelRot.y
	self.rz = modelRot.z
end


function PokeBall_S:updateData()
	self.model:setData("POKEBALLID", self.id, true)
	self.model:setData("isPokeBall", true, true)
end


function PokeBall_S:doCatchProcess()
	if (self.pokemon) and (self.pokemonClass) then
		if (self.currentCount > self.catchTime + 1250) then
			if (self.catchCount < 3) then
				self.catchCount = self.catchCount + 1
				self.catchTime = getTickCount()
				
				local velocity = self.model:getVelocity()
				self.model:setVelocity(0, 0, velocity.z + 0.08)
			else
				self.tryToCatch = false
				self.pokemonClass:setCatchMode(false)
				self.pokemonClass = nil
				self.pokemon = nil
				
				PokeBallManager_S:getSingleton():removePokeBall(self.id)
			end
		end
	end
end


function PokeBall_S:onColShapeHit(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
			
			elseif (element:getType() == "ped") then
				if (self.pokemon == nil) and (self.pokemonClass == nil) and (self.tryToCatch == false) and (isElement(self.player)) then
					if (element:getData("isPokemon") == true) then
						self.pokemon = element
						self.pokemonClass = PokemonManager_S:getSingleton():getPokemonClass(element:getData("POKEMONID"))
						
						if (self.pokemon) and (self.pokemonClass) then
							self.pokemonClass:setCatchMode(true)
							self.pokemonClass:deletePokemon()
							self.tryToCatch = true
							self.catchCount = 0
							self.catchTime = getTickCount()
							self.startCount = getTickCount()
							
							self:updatePosition()
							
							local cameraSettings = {}
							cameraSettings.lookAtX = self.x
							cameraSettings.lookAtY = self.y
							cameraSettings.lookAtZ = self.z - 1
							cameraSettings.distance = 2.5
							cameraSettings.height = 5.0
							cameraSettings.speed = 0.15
							
							triggerClientEvent(self.player, "CLIENTROTATECAMERA", self.player, cameraSettings)
						else
							self.tryToCatch = false
							self.pokemon = nil
							self.pokemonClass = nil
							self.catchTime = 0
						end
					end
				end
			end
		end
	end
end


function PokeBall_S:onColShapeLeave()
	if (isElement(element)) then
		if (element:getType() == "player") then
		
		elseif (element:getType() == "ped") then

		end
	end
end


function PokeBall_S:clear()
	if (self.model) then
		self.model:destroy()
		self.model = nil
	end
	
	if (self.actionCol) then
		removeEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
		removeEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
		
		self.actionCol:destroy()
		self.actionCol = nil
	end
	
	if (self.pokemon) and (self.pokemonClass) then
		self.pokemonClass:setCatchMode(false)
		self.pokemonClass = nil
		self.pokemon = nil
	end
	
	if (self.tryToCatch == true) then
		if (isElement(self.player)) then
			triggerClientEvent(self.player, "CLIENTRESETCAMERA", self.player)
		end
	end
end


function PokeBall_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("PokeBall_S " .. self.id .. " was deleted.")
	end
end
