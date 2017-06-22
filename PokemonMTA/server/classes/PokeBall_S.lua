PokeBall_S = inherit(Class)

function PokeBall_S:constructor(id)
	
	self.id = id
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeBall_S " .. self.id .. " was started.")
	end
end


function PokeBall_S:init()

end


function PokeBall_S:update()
	
end


function PokeBall_S:clear()

end


function PokeBall_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeBall_S " .. self.id .. " was deleted.")
	end
end
