Achievments_S = inherit(Class)

function Achievments_S:constructor(id)
	
	self.id = id

	self.achiements = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Achievments_S " .. self.id .. " was started.")
	end
end


function Achievments_S:init()
	self.achiements["is_registered"] = false
	self.achiements["first_blood"] = false
	self.achiements["first_dead"] = false
end

 
function Achievments_S:update()
	
end


function Achievments_S:clear()
	self.achiements = nil
end


function Achievments_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Achievments_S " .. self.id .. " was deleted.")
	end
end
