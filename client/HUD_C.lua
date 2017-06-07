--[[
	Filename: HUD_C.lua
	Authors: Sam@ke
--]]

HUD_C = {}

function HUD_C:constructor(parent)

	self.renderer = parent
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self:init()
	
	mainOutput("HUD_C was started.")
end


function HUD_C:init()
	self.font = dxCreateFont("res/fonts/pokemon_gb.ttf", 8, false, "proof")
	self.fontBold = dxCreateFont("res/fonts/pokemon_gb.ttf", 8, true, "proof")
	
	if (not self.nameTags) then
		self.nameTags = new(NameTags_C, self)
	end
	
	if (not self.text3D) then
		self.text3D = new(Text3D_C, self)
	end
	
	if (not self.radar) then
		self.radar = new(Radar_C, self)
	end
	
	self.isLoaded = self.font and self.fontBold
end


function HUD_C:update(delta, renderTarget)
	if (self.isLoaded) and (renderTarget) then
		
		if (self.nameTags) then
			self.nameTags:update(delta, renderTarget)
		end
		
		if (self.text3D) then
			self.text3D:update(delta, renderTarget)
		end
		
		if (self.radar) then
			self.radar:update(delta, renderTarget)
		end
		
		dxSetRenderTarget(renderTarget, false)
		
		--dxDrawText("Font Test", 10, 10, self.screenWidth - 10, self.screenHeight / 2 - 10, tocolor(255, 255, 255, 255), 1, self.font, "center", "center", true, true, false, true, true)
		--dxDrawText("Font Test Bold", 10, self.screenHeight / 2 - 10, self.screenWidth - 10, self.screenHeight, tocolor(255, 255, 255, 255), 1, self.fontBold, "center", "center", true, true, false, true, true)
	end
end


function HUD_C:clear()
	if (self.nameTags) then
		delete(self.nameTags)
		self.nameTags = nil
	end
	
	if (self.text3D) then
		delete(self.text3D)
		self.text3D = nil
	end
	
	if (self.radar) then
		delete(self.radar)
		self.radar = nil
	end
	
	if (self.font) then
		--self.font:destroy()
		self.font = nil
	end
	
	if (self.fontBold) then
		--self.fontBold:destroy()
		self.fontBold = nil
	end
end


function HUD_C:destructor()
	self:clear()
	
	mainOutput("HUD_C was deleted.")
end
