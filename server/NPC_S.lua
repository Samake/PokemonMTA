--[[
	Filename: NPC_S.lua
	Authors: Sam@ke
--]]

NPC_S = {}

function NPC_S:constructor(parent, npcProperties)
	
	self.parent = parent
	self.id = npcProperties.id
	self.modelID = npcProperties.modelID
	self.name = npcProperties.name
	self.x = npcProperties.x
	self.y = npcProperties.y
	self.z = npcProperties.z
	self.rx = npcProperties.rx
	self.ry = npcProperties.ry
	self.rz = npcProperties.rz
	
	self.spawn = {x = self.x, y = self.y, z = self.z}
	
	self.actionRadius = 6
	self.distanceToTarget = 0
	
	self.state = nil
	self.job = nil
	self.jobStartTime = 0
	
	self.thinkTime = math.random(2000, 8000)
	
	self.player = nil
	self.isInFight = "false"
	
	self:init()
	
	--mainOutput("NPC_S " .. self.id .. " was started.")
end


function NPC_S:init()
	self:createNPC()
end


function NPC_S:createNPC()
	if (not self.model) then
		self.model = createPed(self.modelID, self.x, self.y, self.z, self.rz, true)
	end
	
	if (not self.actionCol) then
		self.actionCol = createColSphere(self.x, self.y, self.z, self.actionRadius / 2)
	end
	
	if (self.model) and (self.actionCol) then
		self.actionCol:attach(self.model)
		
		self.m_OnColShapeHit = bind(self.onColShapeHit, self)
		self.m_OnColShapeLeave = bind(self.onColShapeLeave, self)
		
		addEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
		addEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
	end
end


function NPC_S:update()
	self.currentTime = getTickCount()
	
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
		self:job_idle()
	end
	
	if (not self.player) then
		if (self.state == "idle") then
			if (self.job == "stand") then
				if (self.currentTime >= self.jobStartTime + self.thinkTime) then
					self:job_idle_pos_change()
				end
			elseif (self.job == "walk") then
				if (self:arrivePosition() == true) then
					self:job_idle()
				end
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
		
		self.model:setAnimation("misc", "idle_chat_02")
		self.model:setFrozen(false)
		
		self.jobStartTime = getTickCount()
		self.thinkTime = math.random(2000, 8000)
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
			self.model:setAnimation("playidles", "stretch")
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
				self.model:setAnimation("ped", "woman_walksexy")
				
				self.state = "idle"
				self.job = "walk"
			end
		end
	end
end


function NPC_S:getInsideSpawnPos()
	if (self.spawn) then
		local x, y, z = getAttachedPosition(self.spawn.x, self.spawn.y, self.spawn.z, 0, 0, 0, math.random(0, self.actionRadius / 2), math.random(0, 360), 1)
		
		while self:isPositionInside(x, y) == false do
			x, y, z = getAttachedPosition(self.spawn.x, self.spawn.y, self.spawn.z, 0, 0, 0, math.random(0, self.actionRadius / 2), math.random(0, 360), 1)
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
		if (x >= self.spawn.x - self.actionRadius / 2) and (x <= self.spawn.x + self.actionRadius / 2) then
			if (y >= self.spawn.y - self.actionRadius / 2) and (y <= self.spawn.y + self.actionRadius / 2) then
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
					self.player = element
					
					self:job_talk_to_player()
					
					local fightProperties = {}
					fightProperties.x = self.x
					fightProperties.y = self.y
					fightProperties.z = self.z
					fightProperties.player = self.player
					fightProperties.opponent = self.model
					fightProperties.opponentID = self.id
					
					triggerEvent("POKEMONSTARTFIGHT", root, fightProperties)
					
					outputChatBox("NPC " .. self.id .. " receives you!")
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
					self.player = nil
					
					self:job_idle()
					
					outputChatBox("You leave npc " .. self.id .. "!")
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
	
	--mainOutput("NPC_S " .. self.id .. " was deleted.")
end
