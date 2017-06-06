--[[
	Filename: PlayerManager_S.lua
	Authors: Sam@ke
--]]

PlayerManager_S = {}

function PlayerManager_S:constructor(parent)

	self.coreClass = parent
	self.playerInstances = {}
	
	self:initManager()
	self:initPlayers()
	
	mainOutput("PlayerManager_S was started.")
end

function PlayerManager_S:initManager()
	self.m_AddPlayer = bind(self.addPlayer, self)
	self.m_RemovePlayer = bind(self.removePlayer, self)
	
	addEvent("onPlayerJoin", true)
	addEvent("onPlayerQuit", true)
	
	addEventHandler("onPlayerJoin", root, self.m_AddPlayer)
	addEventHandler("onPlayerQuit", root, self.m_RemovePlayer)
end


function PlayerManager_S:update()
	for index, instance in pairs(self.playerInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function PlayerManager_S:initPlayers()
	for index, player in pairs(getElementsByType("player")) do
		if (player) then
			if (not self.playerInstances[tostring(player)]) then
				self.playerInstances[tostring(player)] = new(Player_S, tostring(player), player)
			end
		end
	end
end


function PlayerManager_S:addPlayer()
	if (not self.playerInstances[tostring(source)]) then
		self.playerInstances[tostring(source)] = new(Player_S, tostring(source), source)
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


function PlayerManager_S:getPlayers()
	return self.playerInstances
end


function PlayerManager_S:clear()
	for index, instance in pairs(self.playerInstances) do
		if (instance) then
			delete(instance)
			instance = nil
		end
	end
	
	removeEventHandler("onPlayerJoin", root, self.m_AddPlayer)
	removeEventHandler("onPlayerQuit", root, self.m_RemovePlayer)
end


function PlayerManager_S:destructor()
	self:clear()
	
	mainOutput("PlayerManager_S was deleted.")
end

