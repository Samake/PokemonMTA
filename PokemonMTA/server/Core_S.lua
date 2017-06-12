Core_S = inherit(Singleton)

function Core_S:constructor()
	mainOutput("SERVER || ***** " .. Settings.resName .. " was started! " .. Settings.resVersion .. " *****")

	if (Settings.showCoreDebugInfo == true) then
		mainOutput("Core_S was loaded.")
	end
	
	self:initServer()
	self:initComponents()
end


function Core_S:initServer()
	setFPSLimit(Settings.fpsLimit)
	setGameType(Settings.resName)

	self.m_Update = bind(self.update, self)
	
	if (not self.updateTimer) then
		self.updateTimer = setTimer(self.m_Update, Settings.serverUpdateInterval, 0)
	end
end


function Core_S:initComponents()
	PlayerManager_S:new()
	ChestManager_S:new()
	NPCManager_S:new()
	BikeManager_S:new()
	PokeSpawnManager_S:new()
	PokemonManager_S:new()
	ItemManager_S:new()
	FightManager_S:new()
end


function Core_S:update()
	PlayerManager_S:getSingleton():update()
	ChestManager_S:getSingleton():update()
	NPCManager_S:getSingleton():update()
	BikeManager_S:getSingleton():update()
	PokeSpawnManager_S:getSingleton():update()
	PokemonManager_S:getSingleton():update()
	ItemManager_S:getSingleton():update()
	FightManager_S:getSingleton():update()
end


function Core_S:clear()
	if (self.updateTimer) and (self.updateTimer:isValid()) then
		self.updateTimer:destroy()
		self.updateTimer = nil
	end
	
	delete(PlayerManager_S:getSingleton())
	delete(ChestManager_S:getSingleton())
	delete(NPCManager_S:getSingleton())
	delete(BikeManager_S:getSingleton())
	delete(PokeSpawnManager_S:getSingleton())
	delete(PokemonManager_S:getSingleton())
	delete(ItemManager_S:getSingleton())
	delete(FightManager_S:getSingleton())
end


function Core_S:destructor()
	self:clear()

	mainOutput("SERVER || ***** " .. Settings.resName .. " was stopped! " .. Settings.resVersion .. " *****")
	
	if (Settings.showCoreDebugInfo == true) then
		mainOutput("Core_S was deleted.")
	end
end


addEventHandler("onResourceStart", resourceRoot,
function()
	Core_S:new()
end)


addEventHandler("onResourceStop", resourceRoot,
function()
	delete(Core_S:getSingleton())
end)
