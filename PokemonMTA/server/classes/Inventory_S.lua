Inventory_S = inherit(Class)

function Inventory_S:constructor(id)
	
	self.id = id
	self.playerInventory = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Inventory_S " .. self.id .. " was started.")
	end
end


function Inventory_S:init()

end


function Inventory_S:addItem(item, count)
	if (item) and (count) then
		if (not self.playerInventory[item]) then
			self.playerInventory[item] = count
		else
			self.playerInventory[item] = self.playerInventory[item] + count
		end
	end
end


function Inventory_S:removeItem(item, count)
	if (item) and (count) then
		if (self.playerInventory[item]) then
			self.playerInventory[item] = self.playerInventory[item] - count
			
			if (self.playerInventory[item] < 0) then
				self.playerInventory[item] = 0
			end	
		end
	end
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
