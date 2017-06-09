--[[
	Filename: Core_C.lua
	Authors: Sam@ke
--]]

local Instance = nil

Core_C = {}

function Core_C:constructor()
	mainOutput("Core_C was loaded.")
	mainOutput("CLIENT || Pokemon editor plugin started.")
	
	self.isDebug = true

	self:init()
end


function Core_C:init()
	setDevelopmentMode(true, true)
	
	self.m_ToggleDebug = bind(self.toggleDebug, self)
	
	bindKey(Bindings:getDebugKey(), "down", self.m_ToggleDebug)
	
	ModelHandler:init()
	
	if (not self.shaderManager) then
		self.shaderManager = new(ShaderManager_C)
	end
	
	if (not self.debug) then
		self.debug = new(Debug_C, self)
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

	if (deltaTime) then
		self.delta = (1 / 17) * deltaTime
	end

	if (self.shaderManager) then
		self.shaderManager:update(self.delta)
	end
	
	if (self.debug) then
		self.debug:update(self.delta)
	end
end


function Core_C:clear()
	removeEventHandler("onClientPreRender", root, self.m_Update)
	unbindKey(Bindings:getDebugKey(), "down", self.m_ToggleDebug)

	if (self.shaderManager) then
		delete(self.shaderManager)
		self.shaderManager = nil
	end
	
	if (self.debug) then
		delete(self.debug)
		self.debug = nil
	end

	setDevelopmentMode(false, false)
end


function Core_C:destructor()
	self:clear()

	mainOutput("Core_C was deleted.")
	mainOutput("CLIENT || Pokemon editor plugin stopped.")
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
