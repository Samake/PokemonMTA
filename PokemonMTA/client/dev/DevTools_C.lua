--[[
	Filename: DevTools_C.lua
	Authors: Sam@ke
--]]

DevTools_C = {}

function DevTools_C:constructor(parent)

	self.coreClass = parent
	self.player = getLocalPlayer()
	
	self:init()
	
	mainOutput("DevTools_C was started.")
end


function DevTools_C:init()
	self.m_PrintLocation = bind(self.printLocation, self)
	
	bindKey(Bindings:getLocationKey(), "down", self.m_PrintLocation)
end


function DevTools_C:printLocation()
	if (isElement(self.player)) then
		local playerPos = self.player:getPosition()
		local playerRot = self.player:getRotation()
		
		outputConsole ("x = " .. playerPos.x .. ", y = " .. playerPos.y .. ", z = " .. playerPos.z .. ", rx = " .. playerRot.x.. ", ry = " .. playerRot.y .. ", rz = " .. playerRot.z)
	end
end


function DevTools_C:update(delta)

end


function DevTools_C:clear()
	unbindKey(Bindings:getLocationKey(), "down", self.m_PrintLocation)
	
	mainOutput("DevTools_C was deleted.")
end


function DevTools_C:destructor()
	self:clear()
	
end
