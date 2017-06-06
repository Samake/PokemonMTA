--[[
	Filename: Player_C.lua
	Authors: Sam@ke
--]]

Player_C = {}

function Player_C:constructor(parent)

	self.coreClass = parent
	self.player = getLocalPlayer()
	
	self:init()
	
	mainOutput("Player_C was started.")
end


function Player_C:init()
	self.m_ToggleCompanion = bind(self.toggleCompanion, self)
	
	bindKey(Bindings:getCompanionKey(), "down", self.m_ToggleCompanion)
end


function Player_C:update(delta)

end


function Player_C:toggleCompanion()
	triggerServerEvent("DOTOGGLECOMPANION", self.player)
end


function Player_C:clear()
	unbindKey(Bindings:getCompanionKey(), "down", self.m_ToggleCompanion)
	
	mainOutput("Player_C was deleted.")
end


function Player_C:destructor()
	self:clear()
	
end
