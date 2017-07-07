Path_S = inherit(Class)

function Path_S:constructor(id, startX, startY, startZ, endX, endY, endZ)
	
	self.id = id
	self.startX = startX
	self.startY = startY
	self.startZ = startZ
	self.endX = endX
	self.endY = endY
	self.endZ = endZ
	
	self.path = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Path_S " .. self.id .. " was started.")
	end
end


function Path_S:init()
	self.m_Result = bind(self.result, self)
	
	findShortestPathBetween(self.id, self.startX, self.startY, self.startZ, self.endX, self.endY, self.endZ, self.m_Result)
end

 
function Path_S:update()
	
end


function Path_S:result(pathResult)
	if (pathResult) then
		self.path = pathResult
	end
end


function Path_S:getResult()
	return self.path
end


function Path_S:clear()
	unloadPathGraph(self.id)
end


function Path_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Path_S " .. self.id .. " was deleted.")
	end
end
