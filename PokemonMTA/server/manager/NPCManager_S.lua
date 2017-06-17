NPCManager_S = inherit(Singleton)

function NPCManager_S:constructor()

	self.npcInstances = {}
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("NPCManager_S was started.")
	end
end

function NPCManager_S:initManager()
	
	self:initNPCs()
end


function NPCManager_S:initNPCs()
	count = 0
	
	for index, npc in pairs(getElementsByType("NPCSPAWN")) do
		if (npc) then
			
			local npcProperties = {}
			npcProperties.id = index
			npcProperties.modelID = tonumber(npc:getData("skin") or 12)
			npcProperties.x = tonumber(npc:getData("posX") or 0)
			npcProperties.y = tonumber(npc:getData("posY") or 0)
			npcProperties.z = tonumber(npc:getData("posZ") or 0)
			npcProperties.rx = tonumber(npc:getData("rotX") or 0)
			npcProperties.ry = tonumber(npc:getData("rotY") or 0)
			npcProperties.rz = tonumber(npc:getData("rotZ") or 0)
			npcProperties.radius = tonumber(npc:getData("radius") or 0)
			npcProperties.isTrainer = npc:getData("isTrainer") or "false"
			npcProperties.isVendor = npc:getData("isVendor") or "false"
			npcProperties.walkAround = npc:getData("walkAround") or "false"
			npcProperties.reputation = npc:getData("reputation") or "good"
			
			local prefix = ""
			
			if (npcProperties.isTrainer == "true") then
				prefix = "Trainer"
			end
			
			if (npcProperties.isVendor == "true") then
				prefix = "Vendor"
			end
			
			local name = NPC_Helper:getRandomName(npcProperties.modelID) or "UNKNOWN"
			
			npcProperties.name = prefix .. " " .. name
			npcProperties.gender = NPC_Helper:getGender(npcProperties.modelID) or "female"
			
			if (not self.npcInstances[npcProperties.id]) then
				self.npcInstances[npcProperties.id] = NPC_S:new(npcProperties)
				count = count + 1
			end
		end
	end

	if (Settings.showManagerDebugInfo == true) then
		mainOutput("NPCManager_S: " .. count .. " npc instances created!")
	end
end


function NPCManager_S:update()
	for index, instance in pairs(self.npcInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function NPCManager_S:clear()
	for index, instance in pairs(self.npcInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
end


function NPCManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("NPCManager_S was deleted.")
	end
end

