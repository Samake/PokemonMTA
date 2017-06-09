--[[
	Filename: Core_C.lua
	Authors: Sam@ke
--]]

local Instance = nil

Core_C = {}

function Core_C:constructor()
	mainOutput("Core_C was loaded.")

	self.showMTAHUD = false
	self.isDebug = false

	self:init()
end


function Core_C:init()
	setDevelopmentMode(true, true)
	
	self.m_ToggleDebug = bind(self.toggleDebug, self)
	
	bindKey(Bindings:getDebugKey(), "down", self.m_ToggleDebug)
	
	ModelHandler:init()
	Textures:init()
	
	if (not self.effectManager) then
		self.effectManager = new(EffectManager_C)
	end
	
	if (not self.soundManager) then
		self.soundManager = new(SoundManager_C)
	end
	
	if (not self.shaderManager) then
		self.shaderManager = new(ShaderManager_C)
	end
	
	if (not self.camera) then
		self.camera = new(Camera_C, self)
	end
	
	if (not self.player) then
		self.player = new(Player_C, self)
	end
	
	if (not self.debug) then
		self.debug = new(Debug_C, self)
	end
	
	if (not self.devTools) then
		self.devTools = new(DevTools_C, self)
	end
	
	self.m_Update = bind(self.update, self)
	addEventHandler("onClientPreRender", root, self.m_Update)
end


function Core_C:toggleDebug()
	self.isDebug = not self.isDebug
	
	if (self.isDebug) then
		mainOutput("CLIENT || Debug mode enabled!")
	else
		mainOutput("CLIENT || Debug mode disabled!")
	end
end


function Core_C:update(deltaTime)
	setPlayerHudComponentVisible("all", self.showMTAHUD)
	
	if (deltaTime) then
		self.delta = (1 / 17) * deltaTime
	end
	
	if (self.effectManager) then
		self.effectManager:update(self.delta)
	end
	
	if (self.soundManager) then
		self.soundManager:update(self.delta)
	end
	
	if (self.shaderManager) then
		self.shaderManager:update(self.delta)
	end
	
	if (self.camera) then
		self.camera:update(self.delta)
	end
	
	if (self.player) then
		self.player:update(self.delta)
	end
	
	if (self.debug) then
		self.debug:update(self.delta)
	end
	
	if (self.devTools) then
		self.devTools:update(self.delta)
	end
end


function Core_C:clear()
	removeEventHandler("onClientPreRender", root, self.m_Update)
	unbindKey(Bindings:getDebugKey(), "down", self.m_ToggleDebug)
	
	Textures:cleanUp()
	
	if (self.effectManager) then
		delete(self.effectManager)
		self.effectManager = nil
	end
	
	if (self.soundManager) then
		delete(self.soundManager)
		self.soundManager = nil
	end
	
	if (self.shaderManager) then
		delete(self.shaderManager)
		self.shaderManager = nil
	end
	
	if (self.camera) then
		delete(self.camera)
		self.camera = nil
	end
	
	if (self.player) then
		delete(self.player)
		self.player = nil
	end
	
	if (self.debug) then
		delete(self.debug)
		self.debug = nil
	end
	
	if (self.devTools) then
		delete(self.devTools)
		self.devTools = nil
	end

	setDevelopmentMode(false, false)
	setPlayerHudComponentVisible("all", true)
end


function Core_C:destructor()
	self:clear()

	mainOutput("Core_C was deleted.")
end


addEventHandler("onClientResourceStart", resourceRoot,
function()
	Instance = new(Core_C)
end)


addEventHandler("onClientResourceStop", resourceRoot,
function()
	if (Instance) then
		delete(Instance)
		Instance = nil
	end
end)
