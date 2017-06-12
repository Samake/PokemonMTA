DevTools_C = inherit(Singleton)

function DevTools_C:constructor()

	self.player = getLocalPlayer()
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("DevTools_C was started.")
	end
end


function DevTools_C:init()
	self.m_PrintLocation = bind(self.printLocation, self)
	
	bindKey(Bindings["DEVLOCATION"], "down", self.m_PrintLocation)
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
	unbindKey(Bindings["DEVLOCATION"], "down", self.m_PrintLocation)

end


function DevTools_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("DevTools_C was deleted.")
	end
end
