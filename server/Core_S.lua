--[[
	Filename: Core_S.lua
	Authors: Sam@ke
--]]

local Instance = nil

Core_S = {}

function Core_S:constructor()
	mainOutput("SERVER || ***** " .. Settings.resName .. " was started! " .. Settings.resVersion .. " *****")
	mainOutput("Core_S was loaded.")

	self:initServer()
	self:initComponents()
end


function Core_S:initServer()
	setFPSLimit(Settings.fpsLimit)
	
	self.m_Update = bind(self.update, self)
	
	if (not self.updateTimer) then
		self.updateTimer = setTimer(self.m_Update, Settings.serverUpdateInterval, 0)
	end
end


function Core_S:initComponents()
	if (not self.playerManager) then
		self.playerManager = new(PlayerManager_S, self)
	end

	if (not self.spawnManager) then
		self.spawnManager = new(SpawnManager_S, self)
	end
	
	if (not self.itemManager) then
		self.itemManager = new(ItemManager_S, self)
	end
	
	if (not self.fightManager) then
		self.fightManager = new(FightManager_S, self)
	end
end


function Core_S:update()
	if (self.playerManager) then
		self.playerManager:update()
	end

	if (self.spawnManager) then
		self.spawnManager:update()
	end
	
	if (self.itemManager) then
		self.itemManager:update()
	end
	
	if (self.fightManager) then
		self.fightManager:update()
	end
end


function Core_S:clear()
	if (self.updateTimer) and (self.updateTimer:isValid()) then
		self.updateTimer:destroy()
		self.updateTimer = nil
	end
	
	if (self.playerManager) then
		delete(self.playerManager)
		self.playerManager = nil
	end

	if (self.spawnManager) then
		delete(self.spawnManager)
		self.spawnManager = nil
	end
	
	if (self.itemManager) then
		delete(self.itemManager)
		self.itemManager = nil
	end
	
	if (self.fightManager) then
		delete(self.fightManager)
		self.fightManager = nil
	end
	
	mainOutput("Core_S was deleted.")
end


function Core_S:destructor()
	self:clear()

	mainOutput("SERVER || ***** " .. Settings.resName .. " was stopped! " .. Settings.resVersion .. " *****")
end


addEventHandler("onResourceStart", resourceRoot,
function()
	Instance = new(Core_S)
end)


addEventHandler("onResourceStop", resourceRoot,
function()
	if (Instance) then
		delete(Instance)
		Instance = nil
	end
end)
