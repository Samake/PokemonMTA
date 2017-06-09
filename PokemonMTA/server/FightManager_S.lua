--[[
	Filename: FightManager_S.lua
	Authors: Sam@ke
--]]

FightManager_S = {}

function FightManager_S:constructor(parent)

    self.coreClass = parent
	self.playerManager = self.coreClass.playerManager
	self.spawnManager = self.coreClass.spawnManager
	
	self.fights = {}

	self:init()

	mainOutput("FightManager_S was started.")
end


function FightManager_S:init()
	self.m_StartFight = bind(self.startFight, self)
	self.m_StopFight = bind(self.stopFight, self)

	addEvent("POKEMONSTARTFIGHT", true)
	addEventHandler("POKEMONSTARTFIGHT", root, self.m_StartFight)

	addEvent("POKEMONSTOPFIGHT", true)
	addEventHandler("POKEMONSTOPFIGHT", root, self.m_StopFight)
end


function FightManager_S:startFight(fightProperties)
    if (fightProperties) and (self.playerManager) and (self.spawnManager) then
		fightProperties.id = self:getFreeID()
		
		fightProperties.playerClass = self.playerManager:getPlayerClass(fightProperties.player)
		fightProperties.opponentClass = self.spawnManager:getNPCClass(fightProperties.opponentID)

		if (not self.fights[fightProperties.id]) then
			self.fights[fightProperties.id] = new(Fight_S, self, fightProperties)
		end
    end
end


function FightManager_S:update()
	for index, fight in pairs(self.fights) do
		if (fight) then
			fight:update()
		end
	end
end


function FightManager_S:stopFight(id)
	if (id) then
		if (self.fights[id]) then
			delete(self.fights[id])
			self.fights[id] = nil
		end
	end
end


function FightManager_S:getFreeID()
	for index, fight in pairs(self.fights) do
		if (not fight) then
			return index
		end
	end

	return #self.fights + 1
end


function FightManager_S:clear()

	removeEventHandler("POKEMONSTARTFIGHT", root, self.m_StartFight)
	removeEventHandler("POKEMONSTOPFIGHT", root, self.m_StopFight)
	
	for index, fight in pairs(self.fights) do
		if (fight) then
			delete(fight)
			fight = nil
		end
	end

	mainOutput("FightManager_S was deleted.")
end


function FightManager_S:destructor()
	self:clear()	
end
