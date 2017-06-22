PokeBallManager_S = inherit(Singleton)

function PokeBallManager_S:constructor()

	self.pokeBallInstances = {}
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("PokeBallManager_S was started.")
	end
end

function PokeBallManager_S:initManager()
	self.m_AddPokeBall = bind(self.addPokeBall, self)
	
	addEvent("PLAYERTHROWPOKEBALL", true)
	addEventHandler("PLAYERTHROWPOKEBALL", root, self.m_AddPokeBall)
end


function PokeBallManager_S:addPokeBall(pokeBallProperties)
	if (isElement(client)) then
		if (pokeBallProperties) then
			pokeBallProperties.id = self:getFreeID()
			
			if (not self.pokeBallInstances[pokeBallProperties.id]) then
				self.pokeBallInstances[pokeBallProperties.id] = PokeBall_S:new(pokeBallProperties)
			end
		end
	end
end


function PokeBallManager_S:removePokeBall(id)
	if (id) then
		if (self.pokeBallInstances[id]) then
			self.pokeBallInstances[id]:delete()
			self.pokeBallInstances[id] = nil
		end
	end
end


function PokeBallManager_S:update()
	for index, instance in pairs(self.pokeBallInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function PokeBallManager_S:getFreeID()
	for index, instance in pairs(self.pokeBallInstances) do
		if (not instance) then
			return index
		end
	end
	
	return #self.pokeBallInstances + 1
end


function PokeBallManager_S:clear()
	removeEventHandler("PLAYERTHROWPOKEBALL", root, self.m_AddPokeBall)
	
	for index, instance in pairs(self.pokeBallInstances) do
		if (instance) then
			instance:delete()
			instance = nil
		end
	end
end


function PokeBallManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("PokeBallManager_S was deleted.")
	end
end

