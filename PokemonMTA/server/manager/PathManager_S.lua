PathManager_S = inherit(Singleton)

function PathManager_S:constructor()

	self.pathInstances = {}

	self.pathFileStreets = "res/paths/sa_street_nodes.json"
	self.pathFilePeds = "res/paths/sa_ped_nodes.json"
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PathManager_S was started.")
	end
end


function PathManager_S:initManager()
	
	self.path = self:startPathJob(-2427.625, -2474.75, 35.75, 0.0, 0.0, 0.0)
	self.test = "false"
end


function PathManager_S:startPathJob(startX, startY, startZ, endX, endY, endZ)
	if (startX) and (startY) and (startZ) and (endX) and (endY) and (endZ) then
		local id = loadPathGraph("res/paths/sa_nodes.json")
		
		if (not id == false) then
			if (not self.pathInstances[id]) then
				self.pathInstances[id] = Path_S:new(id, startX, startY, startZ, endX, endY, endZ)
				
				return self.pathInstances[id]
			end
		end
	end
	
	return nil
end


function PathManager_S:update()
	for index, instance in pairs(self.pathInstances) do
		if (instance) then
			instance:update()
		end
	end
	
	if (self.path) then
		if (self.path:getResult()) then
			if (self.test == "false") then
				outputServerLog("Path available!")
				outputServerLog("Length: " .. tostring(#self.path:getResult()))
				self.test = "true"
			end
		end
	end
end


function PathManager_S:clear()
	for index, instance in pairs(self.pathInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
end


function PathManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PathManager_S was deleted.")
	end
end

