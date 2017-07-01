Fight_S = inherit(Class)

function Fight_S:constructor(fightProperties)

	self.id = fightProperties.id
	self.x = fightProperties.x
	self.y = fightProperties.y
	self.z = fightProperties.z
	self.playerClass = fightProperties.playerClass
	self.opponentClass = fightProperties.opponentClass
	
	self.dimension = 0
	self.startTime = getTickCount()
	self.currentTime = 0
	
	self.isPrepared = false
	self.isArena = false
	self.isStarted = false

	self:initFight()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Fight_S " .. self.id .. " was started.")
	end
end


function Fight_S:initFight()
	
	if (self.playerClass) and (self.opponentClass) then
		self.player = self.playerClass.player
		self.opponent = self.opponentClass.model
	end
	
	self.isLoaded = isElement(self.player) and self.playerClass and isElement(self.opponent) and self.opponentClass
	
	if (not self.isLoaded) then
		FightManager_S:getSingleton():stopFight(self.id)
	end
end


function Fight_S:prepareArena()
	fadeCamera(self.player, false, 3.0, 255, 255, 255)
	triggerClientEvent(self.player, "CLIENTSTARTTILEFADE", self.player)
	
	self:buildArena()
	self:prepareOpponents()
	
	self.isPrepared = true
end


function Fight_S:buildArena()
	if (not self.arena) then
		local arenaProperties = ArenaManager_S:getSingleton():getNearestArena(self.x, self.y, self.z)
		
		if (arenaProperties) then
			arenaProperties.id = self.id
			arenaProperties.player = self.player
			arenaProperties.playerClass = self.playerClass
			arenaProperties.opponent = self.opponent
			arenaProperties.opponentClass = self.opponentClass
			
			self.arena = Arena_S:new(arenaProperties)
		else
			sendMessage("ERROR || Fight " .. self.id .. " failed to start!")
			self:stopFight()
		end
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
	triggerClientEvent(self.player, "POKEMONSTARTBATTLESOUND", self.player)
	
	fadeCamera (self.player, true, 0.5)
end


function Fight_S:resetCamera()
	triggerClientEvent(self.player, "CLIENTRESETCAMERA", self.player)
	fadeCamera(self.player, true, 0.5)
end


function Fight_S:startFight()
	self.isStarted = true
	self:resetCamera()
	
	sendMessage("SERVER || Fight started: " .. self.player:getName() .. " vs. " .. self.opponentClass.name .. " at Arena: " .. self.arena.name)
end


function Fight_S:stopFight()
	FightManager_S:getSingleton():stopFight(self.id)
	triggerClientEvent(self.player, "POKEMONSTOPBATTLESOUND", self.player)
	
	self.isStarted = false
	self:resetCamera()
	
	sendMessage("SERVER || Fight stopped!")
end


function Fight_S:update()
	if (self.isLoaded) then
		self.currentTime = getTickCount()
		
		if (self.arena) then
			self.arena:update()
		end
		
		if (self.currentTime > self.startTime + 1000) and (self.isPrepared == false) then
			self:prepareArena()
		end
		
		if (self.currentTime > self.startTime + 4000) and (self.isArena == false) then
			self:rotateCamera()
			self.isArena = true
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
		self.arena:delete()
		self.arena = nil
	end
	
	self.opponentClass:setInfight("false")
end


function Fight_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Fight_S " .. self.id .. " was deleted.")
	end
end
