HUD_C = inherit(Class)

function HUD_C:constructor(parent)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self:initHUD()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("HUD_C was started.")
	end
end


function HUD_C:initHUD()
	if (not self.nameTags) then
		self.nameTags = NameTags_C:new()
	end
	
	if (not self.worldText3D) then
		self.worldText3D = WorldText3D_C:new()
	end
	
	if (not self.radar) then
		self.radar = Radar_C:new()
	end
end


function HUD_C:update(delta, renderTarget)
	if (renderTarget) then
		
		if (self.nameTags) then
			self.nameTags:update(delta, renderTarget)
		end
		
		if (self.worldText3D) then
			self.worldText3D:update(delta, renderTarget)
		end
		
		if (self.radar) then
			self.radar:update(delta, renderTarget)
		end
	end
end


function HUD_C:clear()
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
end


function HUD_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("HUD_C was deleted.")
	end
end
