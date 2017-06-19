Computer_S = inherit(Class)

function Computer_S:constructor(computerProperties)
	
	self.id = computerProperties.id
	self.modelID = computerProperties.modelID
	self.x = computerProperties.x
	self.y = computerProperties.y
	self.z = computerProperties.z
	self.rx = computerProperties.rx
	self.ry = computerProperties.ry
	self.rz = computerProperties.rz

	self.actionRadius = 3
	
	self.player = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Computer_S " .. self.id .. " was started.")
	end
end


function Computer_S:init()
	if (not self.element) then
		self.element = createElement("POKECOMPUTER", self.id)
	end
	
	self:createComputer()
end


function Computer_S:createComputer()
	if (not self.model) then
		self.model = createObject(self.modelID, self.x, self.y, self.z, self.rx, self.ry, self.rz, false)
		
		if (not self.actionCol) then
			self.actionCol = createColSphere(self.x, self.y, self.z, self.actionRadius)
		end
		
		if (self.element) and (self.model) and (self.actionCol) then
			self.actionCol:attach(self.model)
			
			self.m_OnColShapeHit = bind(self.onColShapeHit, self)
			self.m_OnColShapeLeave = bind(self.onColShapeLeave, self)
			
			addEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
			addEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
		end
	end
end



function Computer_S:update()
	self.currentTime = getTickCount()
	
	if (self.element) then
		self.element:setPosition(self.x, self.y, self.z)
	end
	
	self:streamComputer()
end



function Computer_S:streamComputer()
	for index, player in pairs(getElementsByType("player")) do
		if (player) and (isElement(player)) then
			if (isElementInRange(player, self.x, self.y, self.z, Settings.drawDistanceComputer)) then
				self:createComputer()
				
				return true
			end
		end
	end
	
	self:deleteComputer()
	
	return false
end



function Computer_S:onColShapeHit(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
				if (not self.player) then
					
					self.player = element
					
					if (not self.light) then
						self.light = createMarker(self.x, self.y, self.z + 1.5, "corona", 1, 90, 90, 175, 220)
					end
					
					triggerClientEvent(self.player, "SHOWCLIENTCOMPUTER", self.player, true)
				end
			end
		end
	end
end


function Computer_S:onColShapeLeave(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
				if (element == self.player) then
					triggerClientEvent(self.player, "SHOWCLIENTCOMPUTER", self.player, false)
					
					self.player = nil
					
					if (self.light) then
						self.light:destroy()
						self.light = nil
					end
				end
			end
		end
	end
	
end


function Computer_S:deleteComputer()

	if (self.model) then
		self.model:destroy()
		self.model = nil
	end
	
	if (self.light) then
		self.light:destroy()
		self.light = nil
	end
	
	if (self.actionCol) then
		removeEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
		removeEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
		
		self.actionCol:destroy()
		self.actionCol = nil
	end
	
	self.player = nil
end


function Computer_S:destructor()
	self:deleteComputer()
	
	if (self.element) then
		self.element:destroy()
		self.element = nil
	end
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Computer_S " .. self.id .. " was deleted.")
	end
end
