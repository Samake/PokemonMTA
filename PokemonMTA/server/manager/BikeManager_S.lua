BikeManager_S = inherit(Singleton)

function BikeManager_S:constructor()

	self.bikeInstances = {}
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("BikeManager_S was started.")
	end
end

function BikeManager_S:initManager()
	
	self:initBikes()
end


function BikeManager_S:initBikes()
	local count = 0
	
	for index, bike in pairs(getElementsByType("BIKESPAWN")) do
		if (bike) then
			
			local bikeProperties = {}
			bikeProperties.id = index
			bikeProperties.x = tonumber(bike:getData("posX") or 0)
			bikeProperties.y = tonumber(bike:getData("posY") or 0)
			bikeProperties.z = tonumber(bike:getData("posZ") or 0)
			bikeProperties.rx = tonumber(bike:getData("rotX") or 0)
			bikeProperties.ry = tonumber(bike:getData("rotY") or 0)
			bikeProperties.rz = tonumber(bike:getData("rotZ") or 0)
			
			if (not self.bikeInstances[bikeProperties.id]) then
				self.bikeInstances[bikeProperties.id] = Bike_S:new(bikeProperties)
				count = count + 1
			end
		end
	end
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("BikeManager_S: " .. count .. " bike instances created!")
	end
end


function BikeManager_S:update()
	for index, instance in pairs(self.bikeInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function BikeManager_S:clear()
	for index, instance in pairs(self.bikeInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
end


function BikeManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("BikeManager_S was deleted.")
	end
end

