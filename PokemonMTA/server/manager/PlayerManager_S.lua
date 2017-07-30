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
			self:createPlayerInstance(player)
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


function PlayerManager_S:addPlayer()
	self:createPlayerInstance(source)
end


function PlayerManager_S:createPlayerInstance(player)
	if (player) and (isElement(player)) then
		local accountName = "samake" -- for test only
		local password = sha256("testpassword") -- for test only
		
		local accountData = MySQLManager_S:getSingleton():getAccountData(accountName)

		local playerSetting = {}
		
		if (accountData) then
			local pos = string.split(accountData.position, "|")
			local rot = string.split(accountData.rotation, "|")
			
			playerSetting.id = accountData.account_id
			playerSetting.accountName = accountData.account_name
			playerSetting.password = accountData.password
			playerSetting.player = player
			playerSetting.skinID = accountData.skin_id or 258
			playerSetting.x = tonumber(pos[1]) or nil
			playerSetting.y = tonumber(pos[2]) or nil
			playerSetting.z = tonumber(pos[3]) or nil
			playerSetting.rx = tonumber(rot[1]) or nil
			playerSetting.ry = tonumber(rot[2]) or nil
			playerSetting.rz = tonumber(rot[3]) or nil
			playerSetting.title = accountData.title or "Beginner"
			playerSetting.playerXP = accountData.player_xp or 0
			playerSetting.playerLevel = accountData.player_level or 1
			playerSetting.money = accountData.money or 0
			playerSetting.pokemonSeen = accountData.pokemon_seen or 0
			playerSetting.pokemonCatched = accountData.pokemon_catched or 0
			playerSetting.pokemonKilled = accountData.pokemon_killed or 0
		else
			playerSetting.id = "new_id"
			playerSetting.accountName = accountName
			playerSetting.password = password
			playerSetting.player = player
			playerSetting.skinID = 258
			playerSetting.x = nil
			playerSetting.y = nil
			playerSetting.z = nil
			playerSetting.rx = nil
			playerSetting.ry = nil
			playerSetting.rz = nil
			playerSetting.title = "Beginner"
			playerSetting.playerXP = 0
			playerSetting.playerLevel = 1
			playerSetting.money = 0
			playerSetting.pokemonSeen = 0
			playerSetting.pokemonCatched = 0
			playerSetting.pokemonKilled = 0
		end
		
		if (not self.playerInstances[playerSetting.id]) then
			self.playerInstances[playerSetting.id] = Player_S:new(playerSetting)
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
		
		local playerID = thePlayer:getData("PLAYERID")
		
		if (playerID) then
			if (self.playerInstances[playerID]) then
				delete(self.playerInstances[playerID])
				self.playerInstances[playerID] = nil
				self.playerCount = self.playerCount - 1
			end
		end
	end
end


function PlayerManager_S:getPlayerClass(player)
	if (player) then
		local playerID = player:getData("PLAYERID")
		
		if (playerID) then
			if (self.playerInstances[playerID]) then
				return self.playerInstances[playerID]
			end
		end
	end
	
	return nil
end


function PlayerManager_S:savePlayerData(playerClass)
	if (playerClass) then
		MySQLManager_S:getSingleton():setAccountData(playerClass)
	end
end


function PlayerManager_S:clear()
	for index, instance in pairs(self.playerInstances) do
		if (instance) then
			self:savePlayerData(instance)
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

