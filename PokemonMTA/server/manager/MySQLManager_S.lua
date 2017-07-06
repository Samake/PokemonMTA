MySQLManager_S = inherit(Singleton)

function MySQLManager_S:constructor()

	self.settings = Settings.dbConnection
	
	self.dbConnection = nil
	
	if (self.settings) then
		self:initManager()
		
		if (Settings.showManagerDebugInfo == true) then
			sendMessage("MySQLManager_S was started.")
		end
	else	
		if (Settings.showManagerDebugInfo == true) then
			sendMessage("MySQLManager_S couln´t be started! See /debugscript 3 for further details!")
		end
	end
	
end


function MySQLManager_S:initManager()
	self:connectDB()
	self:createTables()
	self:loadMySQLData()
	
	self.startTick = getTickCount()
end


function MySQLManager_S:connectDB()
	if (not self.dbConnection) and (self.settings) then
		self.dbConnection = dbConnect(tostring(self.settings.type), "dbname=" .. tostring(self.settings.name) .. ";host=" .. tostring(self.settings.ip), tostring(self.settings.user), tostring(self.settings.pw))
		
		if (self.dbConnection) then
			if (Settings.showManagerDebugInfo == true) then
				sendMessage("SERVER || MySQL connection ready!")
			end
		else
			sendMessage("SERVER || MySQL connection failed:")
			sendMessage("SERVER || MySQL type: " .. tostring(self.settings.type))
			sendMessage("SERVER || MySQL name: " .. tostring(self.settings.name))
			sendMessage("SERVER || MySQL ip: " .. tostring(self.settings.ip))
			sendMessage("SERVER || MySQL user: " .. tostring(self.settings.user))
		end
	end
end


function MySQLManager_S:createTables()
	if (self.dbConnection) then
		if (MySQL.createPlayerTable) then
			local finalString = self.dbConnection:prepareString(MySQL.createPlayerTable)
			self.dbConnection:exec(finalString)
		end
	end
end


function MySQLManager_S:loadMySQLData()
	if (self.dbConnection) then
		self.mySQLQuery = self:query(MySQL.getAllPlayerData)
		
		if (self.mySQLQuery) then
			self.mySQLData = self.mySQLQuery:poll(-1)
			
			if (self.mySQLData) then
				if (#self.mySQLData > 0) then
					if (#self.mySQLData > 0) then
						for index, data in pairs(self.mySQLData) do
							if (data) then
								for id, playerData in pairs(data) do
									outputChatBox(id .. ": " .. tostring(playerData))
								end
							end
						end
					end
				end
			end
			
			self.mySQLQuery:free()
		end
	end
end


function MySQLManager_S:update()
	self.currentTick = getTickCount()
	
	if (self.currentTick > self.startTick + Settings.dbSaveInterVal) then
		self:saveMySQLData()
		self.startTick = getTickCount()
	end
end


function MySQLManager_S:query(statement, ...)
	if (self.dbConnection) then
		local finalString = self.dbConnection:prepareString(statement, ...)
		
		outputChatBox("QUERY: " .. tostring(finalString))
		
		local query = self.dbConnection:query(finalString)
		
		return query
	end
	
	return nil
end


function MySQLManager_S:exec(statement, ...)
	
	if (self.dbConnection) then
		local finalString = self.dbConnection:prepareString(statement, ...)
		
		outputChatBox("EXEC: " .. tostring(finalString))
		return self.dbConnection:exec(finalString)
	end
	
	return nil
end


function MySQLManager_S:saveMySQLData()
	outputChatBox("DB´s saved!")
	
	--if (self.mySQLData == nil) then
		--self.saveState = MySQLManager_S:getSingleton():exec(MySQL.savePlayerData, 1, "username", "password", self.skinID, self.name, self.x .. "|" .. self.y .. "|" .. self.z, self.rx .. "|" .. self.ry .. "|" .. self.rz) -- username, password, skin, name, position, rotation
	--else
	
	--end
	
	--outputChatBox("SaveTest: " .. tostring(self.saveState))
end



function MySQLManager_S:clear()

end


function MySQLManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("MySQLManager_S was deleted.")
	end
end

