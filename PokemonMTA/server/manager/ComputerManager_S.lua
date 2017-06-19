ComputerManager_S = inherit(Singleton)

function ComputerManager_S:constructor()

	self.computerInstances = {}
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("ComputerManager_S was started.")
	end
end

function ComputerManager_S:initManager()
	
	self:initComputers()
end


function ComputerManager_S:initComputers()
	count = 0
	
	for index, pcSpawn in pairs(getElementsByType("PCSPAWN")) do
		if (pcSpawn) then
			
			local computerProperties = {}
			computerProperties.id = index
			computerProperties.modelID = 1853
			computerProperties.x = tonumber(pcSpawn:getData("posX") or 0)
			computerProperties.y = tonumber(pcSpawn:getData("posY") or 0)
			computerProperties.z = tonumber(pcSpawn:getData("posZ") or 0)
			computerProperties.rx = tonumber(pcSpawn:getData("rotX") or 0)
			computerProperties.ry = tonumber(pcSpawn:getData("rotY") or 0)
			computerProperties.rz = tonumber(pcSpawn:getData("rotZ") or 0)

			if (not self.computerInstances[computerProperties.id]) then
				self.computerInstances[computerProperties.id] = Computer_S:new(computerProperties)
				count = count + 1
			end
		end
	end

	if (Settings.showManagerDebugInfo == true) then
		mainOutput("ComputerManager_S: " .. count .. " computer instances created!")
	end
end


function ComputerManager_S:update()
	for index, instance in pairs(self.computerInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function ComputerManager_S:clear()
	for index, instance in pairs(self.computerInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
end


function ComputerManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("ComputerManager_S was deleted.")
	end
end

