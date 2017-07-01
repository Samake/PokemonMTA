ChestManager_S = inherit(Singleton)

function ChestManager_S:constructor()

	self.chestInstances = {}
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ChestManager_S was started.")
	end
end

function ChestManager_S:initManager()
	
	self:initChests()
end


function ChestManager_S:initChests()
	local count = 0
	
	for index, chest in pairs(getElementsByType("CHESTSPAWN")) do
		if (chest) then
			
			local chestProperties = {}
			chestProperties.id = index
			chestProperties.x = tonumber(chest:getData("posX") or 0)
			chestProperties.y = tonumber(chest:getData("posY") or 0)
			chestProperties.z = tonumber(chest:getData("posZ") or 0)
			chestProperties.rx = tonumber(chest:getData("rotX") or 0)
			chestProperties.ry = tonumber(chest:getData("rotY") or 0)
			chestProperties.rz = tonumber(chest:getData("rotZ") or 0)
			
			if (not self.chestInstances[chestProperties.id]) then
				self.chestInstances[chestProperties.id] = Chest_S:new(chestProperties)
				count = count + 1
			end
		end
	end
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ChestManager_S: " .. count .. " chest instances created!")
	end
end


function ChestManager_S:update()
	for index, instance in pairs(self.chestInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function ChestManager_S:clear()
	for index, instance in pairs(self.chestInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
end


function ChestManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ChestManager_S was deleted.")
	end
end

