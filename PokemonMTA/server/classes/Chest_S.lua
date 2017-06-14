Chest_S = inherit(Class)

function Chest_S:constructor(chestProperties)
	
	self.id = chestProperties.id
	self.x = chestProperties.x
	self.y = chestProperties.y
	self.z = chestProperties.z
	self.rx = chestProperties.rx
	self.ry = chestProperties.ry
	self.rz = chestProperties.rz
	
	self.minCoverRot = chestProperties.rx + 42 -- closed chest
	self.maxCoverRot = self.rx  -- opened chest
	self.currentCoverRot = self.minCoverRot
	
	self.state = "closed"
	
	self.modelIDBody = 1851
	self.modelIDCover = 1852
	self.actionRadius = 2
	
	self.activationTime = getTickCount()
	self.currentTime = getTickCount()
	self.refillTimer = math.random(Settings.chestRefillDelay / 2, Settings.chestRefillDelay * 2)
	
	self.player = nil
	
	self.items = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Chest_S " .. self.id .. " was started.")
	end
end


function Chest_S:init()
	if (not self.element) then
		self.element = createElement("CHEST", self.id)
	end
	
	self:createChest()
	self:fillChest()
end


function Chest_S:createChest()
	if (not self.model) then
		self.model = createObject(self.modelIDBody, self.x, self.y, self.z, self.rx, self.ry, self.rz, false)
		
		if (not self.cover) then
			local x, y, z = getAttachedPosition(self.x, self.y, self.z, self.rx, self.ry, self.rz, 0.25, 0, 0.34)
			self.cover = createObject(self.modelIDCover, x, y, z, self.currentCoverRot, self.ry, self.rz, false)
		end
		
		if (not self.actionCol) then
			self.actionCol = createColSphere(self.x, self.y, self.z, self.actionRadius)
		end
		
		if (self.element) and (self.model) and (self.cover) and (self.actionCol) then
			self.actionCol:attach(self.model)
			
			self.m_OnColShapeHit = bind(self.onColShapeHit, self)
			self.m_OnColShapeLeave = bind(self.onColShapeLeave, self)
			
			addEventHandler("onColShapeHit", self.actionCol, self.m_OnColShapeHit)
			addEventHandler("onColShapeLeave", self.actionCol, self.m_OnColShapeLeave)
		end
		
		if (self.state == "wait") then
			if (not self.light) then
				self.light = createMarker(self.x, self.y, self.z + 0.25, "corona", 0.4, 220, 220, 165, 110)
			end
		end
	end
end


function Chest_S:fillChest()
	if (ItemList) then
		self.items = {}
		local itemCount = math.random(0, math.random(1, 9))
	
		for i = 0, itemCount do
			local randomItem = ItemList[math.random(1, #ItemList)]
			
			if (randomItem) then
				if (randomItem.name) then
					if (not self.items[randomItem.name]) then
						self.items[randomItem.name] = {}
						self.items[randomItem.name].count = 1
					else
						if (self.items[randomItem.name].count) then
							self.items[randomItem.name].count = self.items[randomItem.name].count + 1
						end
					end
				end
			end
		end
	end
end


function Chest_S:update()
	self.currentTime = getTickCount()
	
	if (self.element) then
		self.element:setPosition(self.x, self.y, self.z)
	end
	
	self:streamChest()
	self:handleCover()
	
	if (self.state ~= "closed") then
		if (self.currentTime > self.activationTime + self.refillTimer) then
			self:closeChest()
			self:fillChest()
		end
	end
end



function Chest_S:streamChest()
	for index, player in pairs(getElementsByType("player")) do
		if (player) and (isElement(player)) then
			if (isElementInRange(player, self.x, self.y, self.z, Settings.drawDistanceChests)) then
				self:createChest()
				
				return true
			end
		end
	end
	
	self:deleteChest()
	
	return false
end


function Chest_S:closeChest()
	if (self.state == "wait") then
		self.state = "closed"
		
		if (self.light) then
			self.light:destroy()
			self.light = nil
		end
	end
end


function Chest_S:handleCover()
	if (self.cover) then
		if (self.state == "opened") then
			if (self.currentCoverRot > self.maxCoverRot) then
				self.currentCoverRot = self.currentCoverRot - 5
				
				if (self.currentCoverRot < self.maxCoverRot) then
					self.currentCoverRot = self.maxCoverRot
				end
			end
		elseif (self.state == "closed") then
			if (self.currentCoverRot < self.minCoverRot) then
				self.currentCoverRot = self.currentCoverRot + 5
				
				if (self.currentCoverRot > self.minCoverRot) then
					self.currentCoverRot = self.minCoverRot
				end
			end
		end
		
		self.cover:setRotation(self.currentCoverRot, self.ry, self.rz)
	end
end


function Chest_S:onColShapeHit(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
				if (not self.player) then
					if (self.state ~= "opened") then
						if (self.state ~= "wait") then
							local soundSettings = {} 
							soundSettings.soundFile = "res/sounds/effects/open_chest.wav"
							soundSettings.x = self.x
							soundSettings.y = self.y
							soundSettings.z = self.z
							soundSettings.distance = 5
							soundSettings.volume = 0.3
			
							triggerClientEvent("POKEMONPLAY3DSOUND", root, soundSettings)
						end
						
						self.state = "opened"
						
						self.player = element
						
						if (not self.light) then
							self.light = createMarker(self.x, self.y, self.z + 0.25, "corona", 0.4, 220, 220, 165, 110)
						end

						ItemManager_S:getSingleton():getBoxContent(element, self.items, self.x, self.y, self.z)
						
						self.items = {}
					end
				end
			end
		end
	end
end


function Chest_S:onColShapeLeave(element)
	if (element) then
		if (isElement(element)) then
			if (element:getType() == "player") then
				if (element == self.player) then
					self.player = nil
					
					if (self.state ~= "wait") then
						self.state = "wait"
						self.activationTime = getTickCount()
						self.refillTimer = math.random(Settings.chestRefillDelay / 2, Settings.chestRefillDelay * 2)
					end
				end
			end
		end
	end
	
end


function Chest_S:deleteChest()

	if (self.model) then
		self.model:destroy()
		self.model = nil
	end
	
	if (self.cover) then
		self.cover:destroy()
		self.cover = nil
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


function Chest_S:destructor()
	self:deleteChest()
	
	if (self.element) then
		self.element:destroy()
		self.element = nil
	end
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Chest_S " .. self.id .. " was deleted.")
	end
end
