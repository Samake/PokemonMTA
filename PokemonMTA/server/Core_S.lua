Core_S = inherit(Singleton)

function Core_S:constructor()
	sendMessage("SERVER || ***** " .. Settings.resName .. " was started! " .. Settings.resVersion .. " *****")

	if (Settings.showCoreDebugInfo == true) then
		sendMessage("Core_S was loaded.")
	end
	
	self:initServer()
	self:initComponents()
end


function Core_S:initServer()
	setFPSLimit(Settings.fpsLimit)
	setGameType(Settings.resName)

	self.m_Update = bind(self.update, self)
	
	if (Settings.advancedDebugMessages == true) then
		self.m_OnDebugMessage = bind(self.onDebugMessage, self)
		addEventHandler("onDebugMessage", root, self.m_OnDebugMessage)
	end
	
	if (not self.updateTimer) then
		self.updateTimer = setTimer(self.m_Update, Settings.serverUpdateInterval, 0)
	end
end


function Core_S:initComponents()
	MySQLManager_S:new()
	PlayerManager_S:new()
	ChestManager_S:new()
	NPCManager_S:new()
	BikeManager_S:new()
	PokeSpawnManager_S:new()
	PokemonManager_S:new()
	ItemManager_S:new()
	ArenaManager_S:new()
	FightManager_S:new()
	ComputerManager_S:new()
	PokeBallManager_S:new()
	PathManager_S:new()
end


function Core_S:update()
	if (#getElementsByType("player") > 0) then
		local h1, h2, h3 = debug.gethook() 
		debug.sethook() 

		MySQLManager_S:getSingleton():update()
		PlayerManager_S:getSingleton():update()
		ChestManager_S:getSingleton():update()
		NPCManager_S:getSingleton():update()
		BikeManager_S:getSingleton():update()
		PokeSpawnManager_S:getSingleton():update()
		PokemonManager_S:getSingleton():update()
		ItemManager_S:getSingleton():update()
		FightManager_S:getSingleton():update()
		ComputerManager_S:getSingleton():update()
		PokeBallManager_S:getSingleton():update()
		PathManager_S:getSingleton():update()
		
		debug.sethook(_, h1, h2, h3) 
	end
end


function Core_S:onDebugMessage(message, level, file, line)
	if level == 1 then
		outputChatBox("ERROR: " .. file .. ":" .. tostring(line) .. ", " .. message, root, 255, 0, 0)
	elseif level == 2 then
		outputChatBox("WARNING: " .. file .. ":" .. tostring(line) .. ", " .. message, root, 255, 165, 0)
	else
		outputChatBox("INFO: " .. file .. ":" .. tostring(line) .. ", " .. message, root, 0, 0, 255)
	end
	
	outputDebugString(debug.traceback())
end


function Core_S:clear()
	if (self.updateTimer) and (self.updateTimer:isValid()) then
		self.updateTimer:destroy()
		self.updateTimer = nil
	end
	
	delete(PathManager_S:getSingleton())
	delete(PokeBallManager_S:getSingleton())
	delete(ComputerManager_S:getSingleton())
	delete(FightManager_S:getSingleton())
	delete(ArenaManager_S:getSingleton())
	delete(ItemManager_S:getSingleton())
	delete(PokemonManager_S:getSingleton())
	delete(PokeSpawnManager_S:getSingleton())
	delete(BikeManager_S:getSingleton())
	delete(NPCManager_S:getSingleton())
	delete(ChestManager_S:getSingleton())
	delete(PlayerManager_S:getSingleton())
	delete(MySQLManager_S:getSingleton())
end


function Core_S:destructor()
	self:clear()
	
	if (Settings.advancedDebugMessages == true) then
		removeEventHandler("onDebugMessage", root, self.m_OnDebugMessage)
	end
	
	sendMessage("SERVER || ***** " .. Settings.resName .. " was stopped! " .. Settings.resVersion .. " *****")
	
	if (Settings.showCoreDebugInfo == true) then
		sendMessage("Core_S was deleted.")
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
