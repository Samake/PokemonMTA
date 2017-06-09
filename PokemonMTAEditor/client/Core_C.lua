--[[
	Filename: Core_C.lua
	Authors: Sam@ke
--]]

local Instance = nil

Core_C = {}

function Core_C:constructor()
	mainOutput("Core_C was loaded.")
	mainOutput("CLIENT || Pokemon editor plugin started.")

	self:init()
end


function Core_C:init()
	setDevelopmentMode(true, true)
	
	ModelHandler:init()
	
	self.m_Update = bind(self.update, self)
	addEventHandler("onClientPreRender", root, self.m_Update)
end


function Core_C:update(deltaTime)
	if (deltaTime) then
		self.delta = (1 / 17) * deltaTime
	end
	
end


function Core_C:clear()
	removeEventHandler("onClientPreRender", root, self.m_Update)
	
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
