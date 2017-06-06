--[[
	Filename: Fight_S.lua
	Authors: Sam@ke
--]]

Fight_S = {}

function Fight_S:constructor(parent, fightProperties)

    self.fightManager = parent
	self.id = fightProperties.id
	self.x = fightProperties.x
	self.y = fightProperties.y
	self.z = fightProperties.z
	self.player = fightProperties.player
	self.playerClass = fightProperties.playerClass
	self.opponent = fightProperties.opponent
	self.opponentClass = fightProperties.opponentClass
	
	self.dimension = 0
	self.startTime = getTickCount()
	self.currentTime = 0
	
	self.isPrepared = false
	self.isStarted = false

	self:init()

	mainOutput("Fight_S " .. self.id .. " was started.")
end


function Fight_S:init()
	
	fadeCamera(self.player, false, 3.0, 255, 255, 255)
	triggerClientEvent(self.player, "CLIENTSTARTTILEFADE", self.player)
	
	self:buildArena()
	self:prepareOpponents()
	
	self.isLoaded = self.arena and self.player and self.playerClass and self.opponent and self.opponentClass
	
end


function Fight_S:buildArena()
	if (not self.arena) then
		local arenaProperties = ArenaList[1]
		arenaProperties.id = self.id
		arenaProperties.player = self.player
		arenaProperties.opponent = self.opponent
		
		self.arena = new(Arena_S, self, arenaProperties)
	end
end


function Fight_S:prepareOpponents()
	self.opponentClass:setInfight("true")
end


function Fight_S:rotateCamera()
	triggerClientEvent(self.player, "CLIENTSTOPTILEFADE", self.player)
	
	local cameraSettings = {}
	cameraSettings.lookAtX = self.arena.x
	cameraSettings.lookAtY = self.arena.y 
	cameraSettings.lookAtZ = self.arena.z
	cameraSettings.distance = self.arena.radius * 0.85
	cameraSettings.height = 3
	cameraSettings.speed = 0.25

	triggerClientEvent(self.player, "CLIENTROTATECAMERA", self.player, cameraSettings)
	fadeCamera (self.player, true, 0.5)
end


function Fight_S:resetCamera()
	triggerClientEvent(self.player, "CLIENTRESETCAMERA", self.player)
	fadeCamera (self.player, true, 0.5)
end


function Fight_S:startFight()
	self.isStarted = true
	self:resetCamera()
	mainOutput("SERVER || Fight started: " .. self.player:getName() .. " vs. " .. self.opponentClass.name .. " at Arena: " .. self.arena.name)
end


function Fight_S:stopFight()
	triggerEvent("POKEMONSTOPFIGHT", root, self.id)
	
	self.isStarted = false
	self:resetCamera()
	
	mainOutput("SERVER || Fight stopped!")
end


function Fight_S:update()
	if (self.isLoaded) then
		self.currentTime = getTickCount()
		
		self.arena:update()
		
		if (self.currentTime > self.startTime + 3000) and (self.isPrepared == false) then
			self:rotateCamera()
			self.isPrepared = true
		end
		
		if (self.currentTime > self.startTime + 15000) and (self.isStarted == false) then
			if (self.isPrepared == true) then
				self:startFight()
			end
		end
		
		if (self.currentTime > self.startTime + 25000) then
			self:stopFight()
		end
	end
end


function Fight_S:clear()
	if (self.arena) then
		delete(self.arena)
		self.arena = nil
	end
	
	self.opponentClass:setInfight("false")
end


function Fight_S:destructor()
	self:clear()

	mainOutput("Fight_S " .. self.id .. " was deleted.")	
end
