HUD_C = inherit(Class)

function HUD_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self:initHUD()
	
	self.isShowingPokedex = false
	self.isShowingPC = false
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("HUD_C was started.")
	end
end


function HUD_C:initHUD()
	self.m_ShowComputer = bind(self.showComputer, self)
	
	addEvent("SHOWCLIENTCOMPUTER", true)
	addEventHandler("SHOWCLIENTCOMPUTER", root, self.m_ShowComputer)
	
	if (not self.nameTags) then
		self.nameTags = NameTags_C:new()
	end
	
	if (not self.worldText3D) then
		self.worldText3D = WorldText3D_C:new()
	end
	
	if (not self.radar) then
		self.radar = Radar_C:new()
	end
	
	if (not self.pokeSlots) then
		self.pokeSlots = PokeSlots_C:new()
	end
	
	if (not self.pokePC) then
		self.pokePC = PokePC_C:new()
	end
end


function HUD_C:showComputer(bool)
	self.isShowingPC = bool
end


function HUD_C:update(delta, renderTarget)
	if (renderTarget) then
		
		if (self.isShowingPokedex == false) and (self.isShowingPC == false) then
			if (self.nameTags) then
				self.nameTags:update(delta, renderTarget)
			end
			
			if (self.worldText3D) then
				self.worldText3D:update(delta, renderTarget)
			end
			
			if (self.radar) then
				self.radar:update(delta, renderTarget)
			end
			
			if (self.pokeSlots) then
				self.pokeSlots:update(delta, renderTarget)
			end
		elseif (self.isShowingPokedex == true) then
		
		elseif (self.isShowingPC == true) then
			if (self.pokePC) then
				self.pokePC:update(delta, renderTarget)
			end
		end
	end
end


function HUD_C:clear()
	removeEventHandler("SHOWCLIENTCOMPUTER", root, self.m_ShowComputer)
	
	if (self.nameTags) then
		self.nameTags:delete()
		self.nameTags = nil
	end
	
	if (self.worldText3D) then
		self.worldText3D:delete()
		self.worldworldText3D = nil
	end
	
	if (self.radar) then
		self.radar:delete()
		self.radar = nil
	end
	
	if (self.pokeSlots) then
		self.pokeSlots:delete()
		self.pokeSlots = nil
	end
	
	if (self.pokePC) then
		self.pokePC:delete()
		self.pokePC = nil
	end
end


function HUD_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("HUD_C was deleted.")
	end
end
