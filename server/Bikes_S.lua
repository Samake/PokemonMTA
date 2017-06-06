--[[
	Filename: Bikes_S.lua
	Authors: Sam@ke
--]]

Bikes_S = {}

function Bikes_S:constructor(parent, bikeProperties)
	
	self.spawnManager = parent
	
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
	
	self.currentTime = getTickCount()
	self.aloneTime = nil
	
	self:init()
	
	mainOutput("Bikes_S " .. self.id .. " was started.")
end


function Bikes_S:init()
	self:createBikeAtDefault()
end


function Bikes_S:createBikeAtDefault()
	if (not self.element) then
		self.x = self.dx
		self.y = self.dy
		self.z = self.dz
		self.rx = self.drx
		self.ry = self.dry
		self.rz = self.drz
		self.element = createVehicle(self.modelID , self.x, self.y, self.z , self.rx, self.ry, self.rz)
	end
end


function Bikes_S:createBike()
	if (not self.element) then
		self.element = createVehicle(self.modelID , self.x, self.y, self.z , self.rx, self.ry, self.rz)
	end
end


function Bikes_S:update()
	self.currentTime = getTickCount()
	
	self:streamBike()
	
	if (self.element) then
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


function Bikes_S:updateData()
	if (self.element) then
		local bikePos = self.element:getPosition()
		
		self.x = bikePos.x
		self.y = bikePos.y
		self.z = bikePos.z
		
		local bikeRot = self.element:getRotation()
		
		self.rx = bikeRot.x
		self.ry = bikeRot.y
		self.rz = bikeRot.z
	end
end


function Bikes_S:streamBike()
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


function Bikes_S:deleteBike()
	if (self.element) then
		self.element:destroy()
		self.element = nil
	end
end


function Bikes_S:destructor()
	self:deleteBike()
	
	mainOutput("Bikes_S " .. self.id .. " was deleted.")
end
