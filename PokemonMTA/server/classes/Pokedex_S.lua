Pokedex_S = inherit(Class)

function Pokedex_S:constructor(id)
	
	self.id = id

	self.pokedex = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Pokedex_S " .. self.id .. " was started.")
	end
end


function Pokedex_S:init()

end

 
function Pokedex_S:update()
	
end


function Pokedex_S:clear()
	self.pokedex = nil
end


function Pokedex_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Pokedex_S " .. self.id .. " was deleted.")
	end
end
