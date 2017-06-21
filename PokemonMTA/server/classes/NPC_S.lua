NPC_S = inherit(Class)

function NPC_S:constructor(npcProperties)
	
	self.id = npcProperties.id
	self.modelID = npcProperties.modelID
	self.name = npcProperties.name
	self.gender = npcProperties.gender
	self.x = npcProperties.x
	self.y = npcProperties.y
	self.z = npcProperties.z
	self.rx = npcProperties.rx
	self.ry = npcProperties.ry
	self.rz = npcProperties.rz
	self.radius = npcProperties.radius
	self.isTrainer = npcProperties.isTrainer
	self.isVendor = npcProperties.isVendor
	self.walkAround = npcProperties.walkAround
	self.reputation = npcProperties.reputation
	
	self.spawn = {x = self.x, y = self.y, z = self.z}

	self.distanceToTarget = 0
	
	self.state = nil
	self.job = nil
	self.jobStartTime = 0
	
	self.thinkTime = math.random(2000, 8000)
	
	self.player = nil
	self.playerClass = nil
	
	self.isInFight = "false"
	
	self.zone = getZoneName(self.x, self.y, self.z)
	self.wayPoints = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("NPC_S " .. self.id .. " was started.")
	end
end


function NPC_S:init()
	if (not self.element) then
		self.element = createElement("NPC", self.id)
	end
	
	self.animationSet = Animations_S:getNPCAnimations(self.gender)
	
	self:createNPC()
end


function NPC_S:createNPC()
	if (not self.model) then
		self.model = createPed(self.modelID, self.x, self.y, self.z, self.rz, true)
		
		if (not self.actionCol) then
			self.actionCol = createColSphere(self.x, self.y, self.z, 2.5)
		end
		
		if (self.model) and (self.actionCol) then
			self.actionCol:attach(self.model)
			
			self.m_OnColShapeHit = bind(self.onColShapeHit, self)
			self.m_OnColShapeLeave = bind(self.onColShapeLeave, self)
			
			addEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
			addEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
		end
	end
end


function NPC_S:update()
	self.currentTime = getTickCount()
	self.zone = getZoneName(self.x, self.y, self.z)
	
	if (self.isInFight ~= "true") then
	
		if (self.element) then
			self.element:setPosition(self.x, self.y, self.z)
		end
	
		self:streamNPC()
		
		if (isElement(self.model)) then
			if (self.destX) and (self.destY) then
				self.distanceToTarget = getDistanceBetweenPoints2D(self.destX, self.destY, self.x, self.y)
			end
			
			self:handleJobs()
			self:updateCoords()
			self:updateData()
		end
	end
end


function NPC_S:streamNPC()
	for index, player in pairs(getElementsByType("player")) do
		if (player) and (isElement(player)) then
			if (isElementInRange(player, self.x, self.y, self.z, Settings.drawDistanceNPC)) then
				self:createNPC()
				
				return true
			end
		end
	end
	
	self:deleteNPC()
	
	return false
end


function NPC_S:handleJobs()
	if (not self.state) then
		self:job_setDefault()
	end
	
	if (not self.player) then
		if (self.state == "idle") then
			if (self.job == "stand") then
				if (self.currentTime >= self.jobStartTime + self.thinkTime) then
					if (self.radius > 1) then
						self:job_idle_pos_change()
					end
				end
			elseif (self.job == "walk") then
				if (self:arrivePosition() == true) then
					self:job_idle()
				end
			end
		elseif (self.state == "route") then
			if (self:arrivePosition() == true) then
				self:job_setWayPoint()
			end
		end
	else
		self:job_talk_to_player()
	end
end


function NPC_S:updateCoords()
	if (isElement(self.model)) then
		local pos = self.model:getPosition()

		self.x = pos.x
		self.y = pos.y
		self.z = pos.z
		
		local rot = self.model:getRotation()

		self.rx = rot.x
		self.ry = rot.y
		self.rz = rot.z
	end
end


function NPC_S:updateData()
	if (isElement(self.model)) then
		self.model:setData("isNPC", true, true)
		self.model:setData("NPC:NAME", self.name, true)
		self.model:setData("NPC:STATE", self.state, true)
		self.model:setData("NPC:JOB", self.job, true)
		self.model:setData("NPC:ISTRAINER", self.isTrainer, true)
		self.model:setData("NPC:ISVENDOR", self.isVendor, true)
		self.model:setData("NPC:REPUTATION", self.reputation, true)
	end
end


function NPC_S:job_setDefault()
	if (self.walkAround ~= "true")then
		self:job_idle()
	else
		self:job_route()
	end
end


function NPC_S:job_idle()
	if (isElement(self.model)) then
		if (self.spawn) then
			if (self:isPositionInside(self.x, self.y)) then
				self:job_idle_pos_change()
			end
		end
		
		self.state = "idle"
		self.job = "stand"
		
		self.model:setAnimation(self.animationSet.idle.block, self.animationSet.idle.anim)
		self.model:setFrozen(false)
		
		self.jobStartTime = getTickCount()
		self.thinkTime = math.random(2000, 8000)
	end
end


function NPC_S:job_route()
	if (isElement(self.model)) then
		self.state = "route"
		self.job = "walk"
		
		self:job_setWayPoint()
	end
end


function NPC_S:job_setWayPoint()
	if (isElement(self.model)) then
		if (not self.wayPoints) and (self.zone) then
			if (WayPoints) then
				if (WayPoints[self.zone]) then
					if (WayPoints[self.zone][1]) then
						self.wayPoints = WayPoints[self.zone][1]
						self.currentDestination = 1
					end
				end
			end
			
			if (self.wayPoints[self.currentDestination]) then
				self.destX, self.destY = self.wayPoints[self.currentDestination].x, self.wayPoints[self.currentDestination].y
			end
		else
			if (self:arrivePosition() == true) then
				self.currentDestination = self.currentDestination + 1
				
				if (self.currentDestination > #self.wayPoints) then
					self.currentDestination = 1
				end
			end
			
			if (self.wayPoints[self.currentDestination]) then
				self.destX, self.destY = self.wayPoints[self.currentDestination].x, self.wayPoints[self.currentDestination].y
			end
		end
		
		if (self.destX) and (self.destY) then
			self.model:setRotation(0, 0, findRotation(self.x, self.y, self.destX, self.destY))
			self.model:setAnimation(self.animationSet.walk.block, self.animationSet.walk.anim)
		end
	end
end


function NPC_S:job_fight()
	if (isElement(self.model)) then
		self.state = "fight"
		self.job = "frozen"
		self.model:setFrozen(true)
	end
end


function NPC_S:job_talk_to_player()
	if (isElement(self.player)) and (isElement(self.model)) then
		if (self.state ~= "talk") then
			self.state = "talk"
			self.model:setAnimation(self.animationSet.talk.block, self.animationSet.talk.anim)
		end
		
		if (self.job ~= "player") then
			self.job = "player"
		end
		
		local playerPos = self.player:getPosition()
		
		local rot = findRotation(self.x, self.y, playerPos.x, playerPos.y)
		
		self.model:setRotation(self.rx, self.ry, rot)
	end
end


function NPC_S:job_idle_pos_change()
	if (isElement(self.model)) then
		if (self.state == "idle") and (self.job ~= "walk") then
			
			self.destX, self.destY = self:getInsideSpawnPos()

			if (self.destX) and (self.destY) then
				self.model:setRotation(0, 0, findRotation(self.x, self.y, self.destX, self.destY))
				self.model:setAnimation(self.animationSet.walk.block, self.animationSet.walk.anim)
				
				self.state = "idle"
				self.job = "walk"
			end
		end
	end
end


function NPC_S:getInsideSpawnPos()
	if (self.spawn) then
		local x, y, z = getAttachedPosition(self.spawn.x, self.spawn.y, self.spawn.z, 0, 0, 0, math.random(0, self.radius / 2), math.random(0, 360), 1)
		
		while self:isPositionInside(x, y) == false do
			x, y, z = getAttachedPosition(self.spawn.x, self.spawn.y, self.spawn.z, 0, 0, 0, math.random(0, self.radius / 2), math.random(0, 360), 1)
		end
		
		return x, y
	end
	
	return nil
end


function NPC_S:arrivePosition()
	if (self.destX) and (self.destY) then
		if (self.distanceToTarget <= 1.0) then
			return true
		end
		
		return false
	end
	
	return false
end


function NPC_S:isPositionInside(x, y)
	if (x) and (y) then
		if (x >= self.spawn.x - self.radius / 2) and (x <= self.spawn.x + self.radius / 2) then
			if (y >= self.spawn.y - self.radius / 2) and (y <= self.spawn.y + self.radius / 2) then
				return true
			end
		end
		
		return false
	end
end


function NPC_S:onColShapeHit(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
				if (not self.player) and (self.isInFight == "false") then
					
					self.playerClass = PlayerManager_S:getSingleton():getPlayerClass(element)
					
					if (self.playerClass) then
						if (self.playerClass.isInConversation == "false") then
							self.player = element
							
							self.playerClass.isInConversation = "true"
							
							if (self.isTrainer == "true") then 		-- TRAINER
								self.player = element

								local fightProperties = {}
								fightProperties.x = self.x
								fightProperties.y = self.y
								fightProperties.z = self.z
								fightProperties.playerClass = PlayerManager_S:getSingleton():getPlayerClass(element)
								fightProperties.opponentClass = self
								
								FightManager_S:getSingleton():startFight(fightProperties)
							elseif (self.isVendor == "true") then 	-- VENDOR
								self:job_talk_to_player()
							else									-- DEFAULT NPC
								self:job_talk_to_player()
								
								if (Phrases) and (ItemList) then
									if (Phrases["NPC"]) then
										local speechProperties = {}
										local text = "#FFBB66" .. Phrases["NPC"][math.random(1, #Phrases["NPC"])]
										
										if (string.find(text, "<<NAME>>")) then
											text = string.gsub(text, "<<NAME>>", "#66FF66" .. self.name .. "#FFBB66")
										end
										
										if (string.find(text, "<<ITEM>>")) then
											text = string.gsub(text, "<<ITEM>>", "#FF6666" .. ItemList[math.random(1, #ItemList)].name .. "´s#FFBB66")
										end
										
										if (string.find(text, "<<PLAYER>>")) then
											text = string.gsub(text, "<<PLAYER>>", "#9999FF" .. self.playerClass.name .. "#FFBB66")
										end
										
										speechProperties.text = text
										speechProperties.x = self.x
										speechProperties.y = self.y
										speechProperties.z = self.z + 1.5
										
										triggerClientEvent(self.player, "POKEMONSPEECHBUBBLEENABLE", self.player, speechProperties)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


function NPC_S:onColShapeLeave(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
				if (self.player == element) then
					triggerClientEvent(self.player, "POKEMONSPEECHBUBBLEDISABLE", self.player)
					
					self.player = nil
					
					if (self.playerClass) then
						self.playerClass.isInConversation = "false"
						self.playerClass = nil
					end
					
					self:job_setDefault()
				end
			end
		end
	end
end


function NPC_S:setInfight(bool)	
	if (bool) then
		self.isInFight = bool
		
		if (self.isInFight == "true") then
			self:job_fight()
		else
			self:job_idle()
		end
	end
end


function NPC_S:deleteNPC()

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
end


function NPC_S:destructor()
	self:deleteNPC()
	
	if (self.element) then
		self.element:destroy()
		self.element = nil
	end
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("NPC_S " .. self.id .. " was deleted.")
	end
end
