PokeSlots_C = inherit(Class)

function PokeSlots_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.slotWidth = self.screenHeight * 0.25
	self.slotHeight = self.screenHeight * 0.055
	self.x = self.screenWidth - self.slotWidth
	self.y = self.screenHeight / 2.1
	self.space = 2.5
	self.alpha = 220
	
	self.pokeSlots = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeSlots_C was started.")
	end
end


function PokeSlots_C:init()

end


function PokeSlots_C:update(delta, renderTarget)
	if (renderTarget) then
	
		if (Player_C:getSingleton():getPokemons()) then
			self.pokeSlots = Player_C:getSingleton():getPokemons()
		end
	
		dxSetRenderTarget(renderTarget, false)
		dxSetBlendMode("modulate_add")
		
		local color = tocolor(255, 255, 255, self.alpha)
		
		for i = 1, #self.pokeSlots do
			local x = self.x - 5
			local y = ((self.y) + (self.slotHeight * i)) + self.space * i
			
			-- // draw border // --
			dxDrawRectangle (x, y, self.slotWidth, self.slotHeight, tocolor(65, 65, 65, self.alpha), false, true)
			dxDrawImage(x + 2, y + 2, self.slotWidth - 4, self.slotHeight - 4, Textures["gui"].slotBG, 0, 0, 0, color, false)

			if (self.pokeSlots[i]) then
				local slotColor = self.pokeSlots[i].color
				color = tocolor(slotColor.r, slotColor.g, slotColor.b, self.alpha * 0.55)
				
				-- // pokeball // --
				local size = (self.slotHeight / 2) * 0.5
				dxDrawImage(x + 6, y + 6, size, size, Textures["icons"].pokeBallIcon, 0, 0, 0, tocolor(65, 65, 65, self.alpha), false)
				dxDrawImage(x + 4, y + 4, size, size, Textures["icons"].pokeBallIcon, 0, 0, 0, tocolor(255, 255, 255, self.alpha), false)
				
				-- // pokemon icon // --
				local texture
				
				if (Textures["icons"][self.pokeSlots[i].icon]) then
					texture = Textures["icons"][self.pokeSlots[i].icon]
				else
					texture = Textures["icons"].default_icon
				end
				
				-- // pokemon icon // --
				size = self.slotHeight * 0.8
				dxDrawImage((x + (self.slotHeight / 4)) + 2, (y + (self.slotHeight / 8)) + 2, size, size, texture, 0, 0, 0, tocolor(65, 65, 65, self.alpha), false)
				dxDrawImage(x + (self.slotHeight / 4), y + (self.slotHeight / 8), size, size, texture, 0, 0, 0, tocolor(255, 255, 255, self.alpha), false)
				
				-- // pokemon name // --
				dxDrawText(self.pokeSlots[i].name, (x + (self.slotWidth * 0.26)) + 2, (y + (self.slotHeight / 4)) + 2, (x + (self.slotWidth * 0.26)) + 2, (y + (self.slotHeight / 4)) + 2, tocolor(65, 65, 65, self.alpha), 0.7, Fonts["pokemon_gb_8_bold"], "left", "center", false, false, false, true, true)
				dxDrawText(self.pokeSlots[i].name, x + (self.slotWidth * 0.26), y + (self.slotHeight / 4), x + (self.slotWidth * 0.26), y + (self.slotHeight / 4), tocolor(220, 220, 185, self.alpha), 0.7, Fonts["pokemon_gb_8_bold"], "left", "center", false, false, false, true, true)
			else
				-- // pokeball // --
				local size = (self.slotHeight / 2) * 0.5
				dxDrawImage(x + 4, y + 4, size, size, Textures["icons"].pokeBallIconDisabled, 0, 0, 0, tocolor(255, 255, 255, self.alpha), false)
				
				-- // pokemon icon // --
				size = self.slotHeight * 0.8
				dxDrawImage((x + (self.slotHeight / 4)) + 2, (y + (self.slotHeight / 8)) + 2, size, size, Textures["icons"].default_icon, 0, 0, 0, tocolor(65, 65, 65, self.alpha), false)
				dxDrawImage(x + (self.slotHeight / 4), y + (self.slotHeight / 8), size, size, Textures["icons"].default_icon, 0, 0, 0, tocolor(255, 255, 255, self.alpha), false)
				
				-- // pokemon name // --
				dxDrawText("----", (x + (self.slotWidth * 0.26)) + 2, (y + (self.slotHeight / 4)) + 2, (x + (self.slotWidth * 0.26)) + 2, (y + (self.slotHeight / 4)) + 2, tocolor(65, 65, 65, self.alpha), 0.7, Fonts["pokemon_gb_8_bold"], "left", "center", false, false, false, true, true)
				dxDrawText("----", x + (self.slotWidth * 0.26), y + (self.slotHeight / 4), x + (self.slotWidth * 0.26), y + (self.slotHeight / 4), tocolor(220, 220, 185, self.alpha), 0.7, Fonts["pokemon_gb_8_bold"], "left", "center", false, false, false, true, true)
			end
		end
		
		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
end


function PokeSlots_C:clear()
	

end


function PokeSlots_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeSlots_C was deleted.")
	end
end