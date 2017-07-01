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


function MySQLManager_S:clear()

end


function MySQLManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("MySQLManager_S was deleted.")
	end
end

