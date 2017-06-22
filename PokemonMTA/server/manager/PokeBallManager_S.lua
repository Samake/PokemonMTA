PokeBallManager_S = inherit(Singleton)

function PokeBallManager_S:constructor()

	self.pokeBallInstances = {}
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("PokeBallManager_S was started.")
	end
end

function PokeBallManager_S:initManager()
	
end


function PokeBallManager_S:update()
	for index, instance in pairs(self.pokeBallInstances) do
		if (instance) then
			instance:update()
		end
	end
end


function PokeBallManager_S:clear()
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

