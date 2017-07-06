PlayerManager_S = inherit(Singleton)

function PlayerManager_S:constructor()

	self.playerInstances = {}
	
	self.playerCount = 0
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PlayerManager_S was started.")
	end
end

function PlayerManager_S:initManager()
	self.m_AddPlayer = bind(self.addPlayer, self)
	self.m_RemovePlayer = bind(self.removePlayer, self)
	
	addEvent("onPlayerJoin", true)
	addEvent("onPlayerQuit", true)
	
	addEventHandler("onPlayerJoin", root, self.m_AddPlayer)
	addEventHandler("onPlayerQuit", root, self.m_RemovePlayer)
	
	self:initPlayers()
end


function PlayerManager_S:initPlayers()
	for index, player in pairs(getElementsByType("player")) do
		if (player) then
			self:addPlayer(player)
		end
	end
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PlayerManager_S: " .. self.playerCount .. " player instances created!")
	end
end


function PlayerManager_S:update()
	for index, instance in pairs(self.playerInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function PlayerManager_S:addPlayer(player)
	if (source) or (player) then
		local thePlayer = nil
		
		if (not source) then 
			thePlayer = player 
		else 
			thePlayer = source 
		end
		
		if (not self.playerInstances[tostring(thePlayer)]) then
			self.playerInstances[tostring(thePlayer)] = Player_S:new(tostring(thePlayer), thePlayer)
			self.playerCount = self.playerCount + 1
		end
	end
end


function PlayerManager_S:removePlayer(player)
	if (source) or (player) then
		local thePlayer = nil
		
		if (not source) then
			thePlayer = player 
		else 
			thePlayer = source 
		end
		
		if (self.playerInstances[tostring(thePlayer)]) then
			delete(self.playerInstances[tostring(thePlayer)])
			self.playerInstances[tostring(thePlayer)] = nil
			self.playerCount = self.playerCount - 1
		end
	end
end


function PlayerManager_S:getPlayerClass(player)
	if (player) then
		if (self.playerInstances[tostring(player)]) then
			return self.playerInstances[tostring(player)]
		end
	end
	
	return nil
end


function PlayerManager_S:clear()
	for index, instance in pairs(self.playerInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
	
	removeEventHandler("onPlayerJoin", root, self.m_AddPlayer)
	removeEventHandler("onPlayerQuit", root, self.m_RemovePlayer)
end


function PlayerManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PlayerManager_S was deleted.")
	end
end

