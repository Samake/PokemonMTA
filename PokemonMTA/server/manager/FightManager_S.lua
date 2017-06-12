FightManager_S = inherit(Singleton)

function FightManager_S:constructor()

	self.fights = {}

	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("FightManager_S was started.")
	end
end


function FightManager_S:initManager()

end


function FightManager_S:startFight(fightProperties)
    if (fightProperties) then
		fightProperties.id = self:getFreeID()
		
		if (not self.fights[fightProperties.id]) then
			self.fights[fightProperties.id] = Fight_S:new(fightProperties)
		end
    end
end


function FightManager_S:stopFight(id)
	if (id) then
		if (self.fights[id]) then
			self.fights[id]:delete()
			self.fights[id] = nil
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


function FightManager_S:getFreeID()
	for index, fight in pairs(self.fights) do
		if (not fight) then
			return index
		end
	end

	return #self.fights + 1
end


function FightManager_S:clear()
	for index, fight in pairs(self.fights) do
		if (fight) then
			fight:delete()
			fight = nil
		end
	end
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("FightManager_S was deleted.")
	end
end


function FightManager_S:destructor()
	self:clear()	
end
