--[[
	Filename: Pokemon_S.lua
	Authors: Sam@ke
--]]

Pokemon_S = inherit(Class)

function Pokemon_S:constructor(pokemonBluePrint)
	
	self.owner = pokemonBluePrint.owner
	self.id = pokemonBluePrint.id
	self.modelID = pokemonBluePrint.modelID
	self.name = pokemonBluePrint.name or "UNKNOWN"
	self.type = pokemonBluePrint.type or "ground"
	self.legendary = pokemonBluePrint.legendary or "false"
	self.size =	pokemonBluePrint.size or 1
	self.level = pokemonBluePrint.level or 1
	self.power = pokemonBluePrint.power or 100
	self.x = pokemonBluePrint.x or 0
	self.y = pokemonBluePrint.y or 0
	self.z = pokemonBluePrint.z or 0
	self.rx = 0
	self.ry = 0
	self.rz = pokemonBluePrint.rot or 0
	self.radius = pokemonBluePrint.radius or 1
	self.sound = pokemonBluePrint.sound
	self.dimension = pokemonBluePrint.dimension or 0
	
	self.spawn = {x = self.x, y = self.y, z = self.z}
	
	self.distanceToTarget = 0
	
	self.state = nil
	self.job = nil
	self.jobStartTime = 0
	
	self.thinkTime = math.random(500, 6000)

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Pokemon_S " .. self.id .. " was started.")
	end
end


function Pokemon_S:init()
	if (not self.element) then
		self.element = createElement("POKEMON", self.id)
	end
	
	self:createPokemon()
end


function Pokemon_S:createPokemon()
	if (not self.model) then
		self.model = createPed(self.modelID, self.x, self.y, self.z, self.rz, true)
		
		if (not self.actionCol) and (not self.owner) then
			self.actionCol = createColSphere(self.x, self.y, self.z, 6)
		end
		
		if (self.model and self.actionCol) then
			self.actionCol:attach(self.model)
			
			self.m_OnColShapeHit = bind(self.onColShapeHit, self)
			self.m_OnColShapeLeave = bind(self.onColShapeLeave, self)
			
			addEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
			addEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
			
			self.element:setDimension(self.dimension)
			self.actionCol:setDimension(self.dimension)
			self.model:setDimension(self.dimension)
			
			self:doSpawnEffects()
		end
	end
end


function Pokemon_S:doSpawnEffects()
	local effectSettings = {}
	effectSettings.name = "explosion_door"
	effectSettings.x = self.x
	effectSettings.y = self.y
	effectSettings.z = self.z - 1.5
	effectSettings.rx = 0
	effectSettings.ry = 0
	effectSettings.rz = math.random(0, 360)
	effectSettings.duration = 3000
	
	triggerClientEvent("DOCLIENTEFFECT", root, effectSettings)
	
	local soundSettings = {} 
	soundSettings.sound = "res/sounds/effects/whoosh.wav"
	soundSettings.x = self.x
	soundSettings.y = self.y
	soundSettings.z = self.z
	soundSettings.distance = 25
	soundSettings.volume = 0.25
	
	triggerClientEvent("POKEMONPLAY3DSOUND", root, soundSettings)
	
	if (self.sound) then
		local soundSettings = {} 
		soundSettings.sound = self.sound
		soundSettings.x = self.x
		soundSettings.y = self.y
		soundSettings.z = self.z
		soundSettings.distance = 25
		soundSettings.volume = 0.25
		
		triggerClientEvent("POKEMONPLAY3DSOUND", root, soundSettings)
	end
end


function Pokemon_S:doDeleteEffects()
	local effectSettings = {}	
	effectSettings.name = "camflash"
	effectSettings.x = self.x
	effectSettings.y = self.y
	effectSettings.z = self.z - 0.5
	effectSettings.rx = 0
	effectSettings.ry = 0
	effectSettings.rz = math.random(0, 360)
	effectSettings.duration = 1000
	
	triggerClientEvent("DOCLIENTEFFECT", root, effectSettings)
	
	local soundSettings = {} 
	soundSettings.sound = "res/sounds/effects/whoosh.wav"
	soundSettings.x = self.x
	soundSettings.y = self.y
	soundSettings.z = self.z - 0.5
	soundSettings.distance = 25
	soundSettings.volume = 0.25
	
	triggerClientEvent("POKEMONPLAY3DSOUND", root, soundSettings)
end


function Pokemon_S:update()
	self.currentTime = getTickCount()
	
	if (self.element) then
		self.element:setPosition(self.x, self.y, self.z)
	end
	
	if (self.dimension == 0) then
		self:streamPokemon()
	
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


function Pokemon_S:streamPokemon()
	for index, player in pairs(getElementsByType("player")) do
		if (player) and (isElement(player)) then
			if (isElementInRange(player, self.x, self.y, self.z, Settings.drawDistancePokemon)) then
				self:createPokemon()
				
				return true
			end
		end
	end
	
	self:deletePokemon()
	
	return false
end


function Pokemon_S:updateCoords()
	local pos = self.model:getPosition()

	self.x = pos.x
	self.y = pos.y
	self.z = pos.z
	
	local rot = self.model:getRotation()

	self.rx = rot.x
	self.ry = rot.y
	self.rz = rot.z
end


function Pokemon_S:handleJobs()
	if (not self.state) then
		if (self.owner) then
			self:job_follow()
		else
			self:job_idle()
		end
	end
	
	if (self.state == "idle") then
		if (self.job == "stand") then
			if (self.owner) then
				self:job_follow_new_position()
				
				if (self.distanceToTarget > 10) then
					self:job_follow_new_position()
				end
			else
				if (self.currentTime >= self.jobStartTime + self.thinkTime) then
					self:job_idle_pos_change()
				end
			end
		elseif (self.job == "walk") then
			if (self:arrivePosition() == true) then
				self:job_idle()
			end
		end
	elseif (self.state == "flee") then
	
	elseif (self.state == "follow") then
		if (self.job == "walk") then
			self:job_follow_update_position()
			
			if (self:arrivePosition() == true) then
				self:job_idle()
			end
			
			if (self.distanceToTarget > 10) then
				self:job_follow_new_position()
			end
		end
	end
end


function Pokemon_S:updateData()
	self.model:setData("isPokemon", true, true)
	self.model:setData("POKEMON:NAME", self.name, true)
	self.model:setData("POKEMON:LEVEL", self.level, true)
	self.model:setData("POKEMON:LEGENDARY", self.legendary, true)
	self.model:setData("POKEMON:SIZE", self.size, true)
	self.model:setData("POKEMON:POWER", self.power, true)
	self.model:setData("POKEMON:STATE", self.state, true)
	self.model:setData("POKEMON:JOB", self.job, true)
	
	if (self.owner) then
		self.model:setData("POKEMON:COMPANION", "true", true)
	else
		self.model:setData("POKEMON:COMPANION", "false", true)
	end
end


function Pokemon_S:job_flee()
	if (self.state ~= "flee") then
		
		self.destX, self.destY = self:getInsideSpawnPos()

		if (self.destX) and (self.destY) then
			self.model:setRotation(0, 0, findRotation(self.x, self.y, self.destX, self.destY))
			self.model:setAnimation("ped", "woman_run")
			
			self.state = "flee"
			self.job = "walk"
		end
	end
end


function Pokemon_S:job_follow()
	if (self.state ~= "follow") then
		self:job_follow_new_position()
		self.state = "follow"
		self.job = "walk"
	end
end


function Pokemon_S:job_follow_new_position()
	if (self.owner) then
		local pos = self.owner:getPosition()
		local rot = self.owner:getRotation()
		self.destX, self.destY = getAttachedPosition(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, 180, 1)

		if (self.destX) and (self.destY) then
			if (self.distanceToTarget > 4) then
				self.model:setRotation(0, 0, findRotation(self.x, self.y, self.destX, self.destY))
				self.model:setAnimation("ped", "woman_runpanic")
				
				self.state = "follow"
				self.job = "walk"
			else
				self.state = "idle"
				self.job = "stand"
			end
		end
	end
end

function Pokemon_S:job_follow_update_position()
	if (self.owner) then
		local pos = self.owner:getPosition()
		local rot = self.owner:getRotation()
		self.destX, self.destY = getAttachedPosition(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, 180, 1)
	end
end


function Pokemon_S:job_idle()
	if (self:isPositionInside(self.x, self.y)) then
		self:job_idle_pos_change()
	end
	
	self.state = "idle"
	self.job = "stand"
	
	self.model:setAnimation("ped", "idle_tired")
	
	self.jobStartTime = getTickCount()
	self.thinkTime = math.random(500, 2500)
end


function Pokemon_S:job_idle_pos_change()
	if (self.state == "idle") and (self.job ~= "walk") then
		
		self.destX, self.destY = self:getInsideSpawnPos()

		if (self.destX) and (self.destY) then
			self.model:setRotation(0, 0, findRotation(self.x, self.y, self.destX, self.destY))
			self.model:setAnimation("ped", "woman_walknorm")
			
			self.state = "idle"
			self.job = "walk"
		end
	end
end


function Pokemon_S:getInsideSpawnPos()
	if (self.spawn) then
		local x, y, z = getAttachedPosition(self.spawn.x, self.spawn.y, self.spawn.z, 0, 0, 0, math.random(0, self.radius / 2), math.random(0, 360), 1)
		
		while self:isPositionInside(x, y) == false do
			x, y, z = getAttachedPosition(self.spawn.x, self.spawn.y, self.spawn.z, 0, 0, 0, math.random(0, self.radius / 2), math.random(0, 360), 1)
		end
		
		return x, y
	end
	
	return nil
end


function Pokemon_S:isPositionInside(x, y)
	if (x) and (y) then
		if (x >= self.x - self.radius / 2) and (x <= self.x + self.radius / 2) then
			if (y >= self.y - self.radius / 2) and (y <= self.y + self.radius / 2) then
				return true
			end
		end
		
		return false
	end
end


function Pokemon_S:arrivePosition()
	if (self.destX) and (self.destY) then
		if (self.distanceToTarget <= 1.5) then
			return true
		end
		
		return false
	end
	
	return false
end


function Pokemon_S:onColShapeHit(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
				if (element == self.owner) then
					self:job_idle()
				else
					self:job_flee()
				end
			end
		end
	end
end


function Pokemon_S:onColShapeLeave(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
				if (element == self.owner) then
					self:job_idle()
				else
					self:job_idle()
				end
			end
		end
	end
end


function Pokemon_S:deletePokemon()
	if (self.model) then
		self.model:destroy()
		self.model = nil
	end
	
	if (self.actionCol) then
		removeEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
		removeEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
		
		self.actionCol:destroy()
		self.actionCol = nil
		
		self:doDeleteEffects()
	end
end


function Pokemon_S:destructor()
	self:deletePokemon()
	
	if (self.element) then
		self.element:destroy()
		self.element = nil
	end
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Pokemon_S " .. self.id .. " was deleted.")
	end
end
