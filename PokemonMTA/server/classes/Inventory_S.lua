Inventory_S = inherit(Class)

function Inventory_S:constructor(id)
	
	self.id = id
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Inventory_S " .. self.id .. " was started.")
	end
end


function Inventory_S:init()

end

 
function Inventory_S:update()

end


function Inventory_S:clear()

end


function Inventory_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Inventory_S " .. self.id .. " was deleted.")
	end
end
