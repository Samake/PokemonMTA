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
	self.lifeTime = 8000
	
	self.mass = 5
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("PokeBall_S " .. self.id .. " was started.")
	end
end


function PokeBall_S:init()
	if (not self.model) then
		self.model = createVehicle(self.modelID, self.x, self.y, self.z, self.rx, self.ry, self.rz)
		self.model:setDamageProof(true)
		setVehicleHandling(self.model, "mass", self.mass)
		setVehicleLocked(self.model, true)
		setVehicleEngineState(self.model, false)
	end
	
	self.startCount = getTickCount()
	
	self:throwPokeBall()
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


function PokeBall_S:clear()
	if (self.model) then
		self.model:destroy()
		self.model = nil
	end
end


function PokeBall_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("PokeBall_S " .. self.id .. " was deleted.")
	end
end
