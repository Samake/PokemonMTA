Bike_S = inherit(Class)

function Bike_S:constructor(bikeProperties)
	
	self.id = bikeProperties.id
	self.x = bikeProperties.x
	self.y = bikeProperties.y
	self.z = bikeProperties.z
	self.rx = bikeProperties.rx
	self.ry = bikeProperties.ry
	self.rz = bikeProperties.rz
	
	self.dx = bikeProperties.x
	self.dy = bikeProperties.y
	self.dz = bikeProperties.z
	self.drx = bikeProperties.rx
	self.dry = bikeProperties.ry
	self.drz = bikeProperties.rz

	self.modelID = 481
	
	self.color1 = {r = 0, g = 0, b = 0}
	self.color2 = {r = 0, g = 0, b = 0}
	self.color3 = {r = 0, g = 0, b = 0}
	self.color4 = {r = 0, g = 0, b = 0}
	
	self.currentTime = getTickCount()
	self.aloneTime = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Bike_S " .. self.id .. " was started.")
	end
end


function Bike_S:init()
	self:createBikeAtDefault()
end


function Bike_S:createBikeAtDefault()
	if (not self.bike) then
		self.x = self.dx
		self.y = self.dy
		self.z = self.dz
		self.rx = self.drx
		self.ry = self.dry
		self.rz = self.drz
		self.bike = createVehicle(self.modelID , self.x, self.y, self.z , self.rx, self.ry, self.rz)
		
		if (self.bike) then
			self.color1.r, self.color1.g, self.color1.b, self.color2.r, self.color2.g, self.color2.b, self.color3.r, self.color3.g, self.color3.b, self.color4.r, self.color4.g, self.color4.b = self.bike:getColor()
		end
	end
end


function Bike_S:createBike()
	if (not self.bike) then
		self.bike = createVehicle(self.modelID , self.x, self.y, self.z , self.rx, self.ry, self.rz)
		
		if (self.bike) then
			self.bike:setColor(self.color1.r, self.color1.g, self.color1.b, self.color2.r, self.color2.g, self.color2.b, self.color3.r, self.color3.g, self.color3.b, self.color4.r, self.color4.g, self.color4.b)
		end
	end
end


function Bike_S:update()
	self.currentTime = getTickCount()
	
	self:streamBike()
	
	if (self.bike) then
		self.aloneTime = nil
		self:updateData()
	else
		if (not self.aloneTime) then
			self.aloneTime = getTickCount()
		else
			if (self.currentTime > self.aloneTime + Settings.bikeRespawnDelay) then
				self:createBikeAtDefault()
			end
		end
	end
end


function Bike_S:updateData()
	if (self.bike) then
		local bikePos = self.bike:getPosition()
		
		self.x = bikePos.x
		self.y = bikePos.y
		self.z = bikePos.z
		
		local bikeRot = self.bike:getRotation()
		
		self.rx = bikeRot.x
		self.ry = bikeRot.y
		self.rz = bikeRot.z
	end
end


function Bike_S:streamBike()
	for index, player in pairs(getElementsByType("player")) do
		if (player) and (isElement(player)) then
			if (isElementInRange(player, self.x, self.y, self.z, Settings.drawDistanceBikes)) then
				self:createBike()
				
				return true
			end
		end
	end
	
	self:deleteBike()
	
	return false
end


function Bike_S:deleteBike()
	if (self.bike) then
		self.bike:destroy()
		self.bike = nil
	end
end


function Bike_S:destructor()
	self:deleteBike()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Bike_S " .. self.id .. " was deleted.")
	end
end
