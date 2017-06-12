Player_C = inherit(Singleton)

function Player_C:constructor()

	self.player = getLocalPlayer()
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_C was started.")
	end
end


function Player_C:init()
	self.m_ToggleCompanion = bind(self.toggleCompanion, self)
	
	bindKey(Bindings["COMPANION"], "down", self.m_ToggleCompanion)
end


function Player_C:update(delta)

end


function Player_C:toggleCompanion()
	triggerServerEvent("DOTOGGLECOMPANION", self.player)
end


function Player_C:clear()
	unbindKey(Bindings["COMPANION"], "down", self.m_ToggleCompanion)
	
end


function Player_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_C was deleted.")
	end
end
