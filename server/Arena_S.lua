--[[
	Filename: Arena_S.lua
	Authors: Sam@ke
--]]

Arena_S = {}

function Arena_S:constructor(parent, arenaProperties)

    self.fight = parent
	
	self.id = arenaProperties.id
	self.name = arenaProperties.name
	self.x = arenaProperties.x
	self.y = arenaProperties.y
	self.z = arenaProperties.z
	self.player = arenaProperties.player
	self.playerClass = arenaProperties.playerClass
	self.opponent = arenaProperties.opponent
	self.opponentClass = arenaProperties.opponentClass
	
	self.spot1Player = {x = self.x - 8, y = self.y, z = self.z}
	self.spot1Pokemon = {x = self.x - 7, y = self.y + 1, z = self.z}
	self.spot2Opponent = {x = self.x + 8, y = self.y, z = self.z}
	self.spot2Pokemon = {x = self.x + 7, y = self.y + 1, z = self.z}
	
	self.defaultDimension = 0
	self.arenaDimension = self.id
	
	self.maxSpectors = 35
	self.maxEffects = 18
	self.radius = 20
	
	self.spectators = {}
	
	self:init()

	mainOutput("Arena_S " .. self.name .. ":" .. self.id .. " was started.")
end


function Arena_S:init()
	
	self.isLoaded = self.fight and isElement(self.player) and self.playerClass and isElement(self.opponent) and self.opponentClass
	
	if (not self.isLoaded) then
		self.fight.fightManager:stopFight(self.id)
	else
		self:addSpectators()
		self:addEffects()
		self:setOpponents()
	end
end


function Arena_S:addSpectators()
	local step = 360 / self.maxSpectors
	
	for i = 1, self.maxSpectors do
		if (not self.spectators[i]) and (SpawnList.npcs) then
			local x, y, z = getAttachedPosition(self.x, self.y, self.z, 0, 0, 0, self.radius, step * i, 1)
			local rot = findRotation(x, y, self.x, self.y)
			local randomPed = SpawnList.npcs[math.random(1, #SpawnList.npcs)]
			
			self.spectators[i] = createPed(randomPed.modelID, x, y, z, rot, true)
		end
	end
	
	for index, spectator in pairs(self.spectators) do
		if (spectator) then
			spectator:setAnimation("dancing", "dan_loop_a")
			spectator:setDimension(self.arenaDimension)
		end
	end
end


function Arena_S:addEffects()
	local step = 360 / self.maxEffects
	
	local effectsTable = {}
	
	effectsTable.id = self.name .. ":" .. self.id
	effectsTable.name = "WS_factorysmoke"
	effectsTable.effects = {}
	
	for i = 1, self.maxEffects do
		local ex, ey, ez = getAttachedPosition(self.x, self.y, self.z, 0, 0, 0, self.radius + 5, step * i, 0)
		
		effectsTable.effects[i] = {x = ex, y = ey, z = ez - 0.5}
	end
	
	triggerClientEvent(self.player, "DOCLIENTMASSEFFECT", self.player, effectsTable)
end


function Arena_S:setOpponents()
	self:savePositions()
	self:spawnPlayer()
	self:spawnOpponent()
end


function Arena_S:savePositions()
	self.playerPositionSaved = self.player:getPosition()
	self.playerRotationSaved = self.player:getRotation()
	self.opponentPositionSaved = self.opponent:getPosition()
	self.opponentRotationSaved = self.opponent:getRotation()	
end


function Arena_S:spawnPlayer()
	local rotZ = findRotation(self.spot1Player.x, self.spot1Player.y, self.x, self.y)
	local playerRot = self.player:getRotation()
	
	self.player:setDimension(self.arenaDimension)
	self.player:setPosition(self.spot1Player.x, self.spot1Player.y, self.spot1Player.z)
	self.player:setRotation(playerRot.x, playerRot.y, rotZ)
	self.player:setFrozen(true, true)
end


function Arena_S:resetPlayer()
	if (self.playerPositionSaved) and (self.playerRotationSaved) then
		self.player:setDimension(self.defaultDimension)
		self.player:setPosition(self.playerPositionSaved.x, self.playerPositionSaved.y, self.playerPositionSaved.z)
		self.player:setRotation(self.playerRotationSaved.x, self.playerRotationSaved.y, self.playerRotationSaved.z)
		self.player:setFrozen(false, false)
	end
end


function Arena_S:spawnOpponent()
	local rotZ = findRotation(self.spot2Opponent.x, self.spot2Opponent.y, self.x, self.y)
	local opponentRot = self.opponent:getRotation()

	self.opponent:setDimension(self.arenaDimension)
	self.opponent:setPosition(self.spot2Opponent.x, self.spot2Opponent.y, self.spot2Opponent.z)
	self.opponent:setRotation(opponentRot.x, opponentRot.y, rotZ)
	self.opponent:setFrozen(true)
end


function Arena_S:resetOpponent()
	if (self.opponentPositionSaved) and (self.opponentRotationSaved) then
		self.opponent:setDimension(self.defaultDimension)
		self.opponent:setPosition(self.opponentPositionSaved.x, self.opponentPositionSaved.y, self.opponentPositionSaved.z)
		self.opponent:setRotation(self.opponentRotationSaved.x, self.opponentRotationSaved.y, self.opponentRotationSaved.z)
		self.opponent:setFrozen(false)
	end
end


function Arena_S:update()
	if (self.isLoaded) then
		self:setRotations()
	end
end


function Arena_S:setRotations()
	local rotZ = findRotation(self.spot1Player.x, self.spot1Player.y, self.x, self.y)
	local playerRot = self.player:getRotation()
	
	self.player:setRotation(playerRot.x, playerRot.y, rotZ)
	
	local rotZ = findRotation(self.spot2Opponent.x, self.spot2Opponent.y, self.x, self.y)
	local opponentRot = self.opponent:getRotation()
	
	self.opponent:setRotation(opponentRot.x, opponentRot.y, rotZ)
end


function Arena_S:clear()
	self:resetPlayer()
	self:resetOpponent()
	
	for index, spectator in pairs(self.spectators) do
		if (spectator) then
			spectator:destroy()
			spectator = nil
		end
	end
	
	triggerClientEvent(self.player, "DELETECLIENTMASSEFFECT", self.player, self.name .. ":" .. self.id)
end


function Arena_S:destructor()
	self:clear()	
	
	mainOutput("Arena_S " .. self.name .. ":" .. self.id .. " was deleted.")
end
