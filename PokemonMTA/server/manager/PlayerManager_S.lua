PlayerManager_S = inherit(Singleton)

function PlayerManager_S:constructor()

	self.playerInstances = {}
	
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
	local count = 0
	
	for index, player in pairs(getElementsByType("player")) do
		if (player) then
			if (not self.playerInstances[tostring(player)]) then
				self.playerInstances[tostring(player)] = Player_S:new(tostring(player), player)
				count = count +1 
			end
		end
	end
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("PlayerManager_S: " .. count .. " player instances created!")
	end
end


function PlayerManager_S:update()
	for index, instance in pairs(self.playerInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function PlayerManager_S:addPlayer()
	if (not self.playerInstances[tostring(source)]) then
		self.playerInstances[tostring(source)] = Player_S:new(tostring(source), source)
	end
end


function PlayerManager_S:removePlayer()
	if (self.playerInstances[tostring(source)]) then
		delete(self.playerInstances[tostring(source)])
		self.playerInstances[tostring(source)] = nil
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

