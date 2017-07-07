MySQLManager_S = inherit(Singleton)

function MySQLManager_S:constructor()

    self.settings = Settings.dbConnection
    
    self.dbConnection = nil
    self.accountData = {}
    
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
        self.mySQLQuery = self:query(MySQL.getAllAccountData)
        
        if (self.mySQLQuery) then
            self.mySQLData = self.mySQLQuery:poll(-1)
            
            if (self.mySQLData) then
                if (#self.mySQLData > 0) then
                    for index, account in pairs(self.mySQLData) do
                        if (account) then
                            if (not self.accountData[account.account_name]) then
                                self.accountData[account.account_name] = account
                            end
                        end
                    end
                end
            end
            
            self.mySQLQuery:free()
        end
        
        sendMessage("SERVER || Database were loaded!")
    end
end


function MySQLManager_S:getAccountData(accountName)
    if (accountName) then
        if (self.accountData[accountName]) then
            return self.accountData[accountName]
        end
    end
    
    return nil
end


function MySQLManager_S:setAccountData(playerClass)
    if (playerClass) then
        self.accountData[playerClass.accountName] = {}
        self.accountData[playerClass.accountName].account_id = playerClass.id
        self.accountData[playerClass.accountName].account_name = playerClass.accountName
        self.accountData[playerClass.accountName].password = playerClass.password
        self.accountData[playerClass.accountName].skin_id = playerClass.skinID
        self.accountData[playerClass.accountName].player_name = playerClass.playerName
        self.accountData[playerClass.accountName].position = playerClass.x .. "|" .. playerClass.y .. "|" .. playerClass.z
        self.accountData[playerClass.accountName].rotation = playerClass.rx .. "|" .. playerClass.ry .. "|" .. playerClass.rz
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
        --outputChatBox(tostring(finalString))
        
        return self.dbConnection:query(finalString)
    end
    
    return nil
end


function MySQLManager_S:exec(statement, ...)
    
    if (self.dbConnection) then
        local finalString = self.dbConnection:prepareString(statement, ...)
        --outputChatBox(tostring(finalString))
        
        return self.dbConnection:exec(finalString)
    end
    
    return nil
end


function MySQLManager_S:saveMySQLData()
    sendMessage("SERVER || Database were saved!")
    
    for index, accountData in pairs(self.accountData) do
        if (accountData) then
            self.mySQLQuery = self:query(MySQL.getAccountData, accountData.account_name)
            
            if (self.mySQLQuery) then
                self.mySQLData = self.mySQLQuery:poll(-1)
                
                if (self.mySQLData) then
                    if (#self.mySQLData > 0) then
                        self:exec(MySQL.updateAccountData, accountData.account_name, accountData.password, accountData.skin_id, accountData.player_name, accountData.position, accountData.rotation, accountData.account_id)
                    else
                        self:exec(MySQL.saveAccountData, accountData.account_id, accountData.account_name, accountData.password, accountData.skin_id, accountData.player_name, accountData.position, accountData.rotation)
                    end
                end
                
                self.mySQLQuery:free()
            end
        end
    end
end


function MySQLManager_S:clear()
    self:saveMySQLData()
end


function MySQLManager_S:destructor()
    self:clear()
    
    if (Settings.showManagerDebugInfo == true) then
        sendMessage("MySQLManager_S was deleted.")
    end
end

